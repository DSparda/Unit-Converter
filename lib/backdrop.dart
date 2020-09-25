import 'package:flutter/material.dart';
import 'package:hello_flutter/caterory.dart';
import 'dart:math' as math;

const double _kFlingVelocity = 2.0;

class _BackdropPanel extends StatelessWidget {
  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;

  const _BackdropPanel(
      {Key key,
      this.onTap,
      this.onVerticalDragUpdate,
      this.onVerticalDragEnd,
      this.child,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.subtitle1,
                child: title,
              ),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Expanded(child: child)
        ],
      ),
    );
  }
}

class _BackdropTile extends AnimatedWidget {
  final Widget frontTile;
  final Widget backTile;

  const _BackdropTile(
      {Key key, Listenable listenable, this.frontTile, this.backTile})
      : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.headline6,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
                    parent: ReverseAnimation(animation),
                    curve: Interval(0.5, 1.0))
                .value,
            child: backTile,
          ),
          Opacity(
            opacity:
                CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0))
                    .value,
            child: frontTile,
          ),
        ],
      ),
    );
  }
}

class Backdrop extends StatefulWidget {
  final Caterory currentCategory;
  final Widget frontPanel;
  final Widget backPanel;
  final Widget frontTile;
  final Widget backTile;

  const Backdrop(
      {@required this.frontTile,
      @required this.backTile,
      @required this.backPanel,
      @required this.currentCategory,
      @required this.frontPanel})
      : assert(backPanel != null),
        assert(frontPanel != null),
        assert(frontTile != null),
        assert(backTile != null),
        assert(currentCategory != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 300), value: 1.0, vsync: this);
  }

  @override
  void didUpdateWidget(Backdrop old) {
    super.didUpdateWidget(old);
    if (widget.currentCategory != old.currentCategory) {
      setState(() {
        _controller.fling(
            velocity:
                _backdropPanelVisible ? -_kFlingVelocity : _kFlingVelocity);
      });
    } else if (!_backdropPanelVisible) {
      setState(() {
        _controller.fling(velocity: _kFlingVelocity);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibilty() {
    FocusScope.of(context).requestFocus(FocusNode());
    _controller.fling(
        velocity: _backdropPanelVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    _controller.value -= details.primaryDelta / _backdropHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(_kFlingVelocity, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(_kFlingVelocity, -flingVelocity));
    else
      _controller.fling(
          velocity:
              _controller.value < 0.5 ? -_kFlingVelocity : _kFlingVelocity);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    Animation<RelativeRect> panelAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, panelTop, 0.0, panelTop - panelSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Container(
      key: _backdropKey,
      color: widget.currentCategory.color,
      child: Stack(
        children: <Widget>[
          widget.backPanel,
          PositionedTransition(
              rect: panelAnimation,
              child: _BackdropPanel(
                onTap: _toggleBackdropPanelVisibilty,
                onVerticalDragEnd: _handleDragEnd,
                onVerticalDragUpdate: _handleDragUpdate,
                title: Text(widget.currentCategory.name),
                child: widget.frontPanel,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.currentCategory.color,
        elevation: 0.0,
        leading: IconButton(
            onPressed: _toggleBackdropPanelVisibilty,
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: _controller.view,
            )),
        title: _BackdropTile(
          listenable: _controller.view,
          frontTile: widget.frontTile,
          backTile: widget.backTile,
        ),
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}
