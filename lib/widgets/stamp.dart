import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookzone/components/loading_widget.dart';
import 'package:uuid/uuid.dart';

class Stamp extends StatefulWidget {
  Stamp(this.imageUrl, this.title, {this.onClick});

  final bool withStartAnimation = false;
  final String imageUrl;
  final String title;

  final VoidCallback onClick;

  @override
  State<StatefulWidget> createState() => new _StampState();
}

class _StampState extends State<Stamp> with SingleTickerProviderStateMixin {
//  AnimationController animationController;
  Animation animation;
  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  @override
  void initState() {
    super.initState();
    //  animationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 1000));

    //   animation  = new Tween(begin: 0.0, end: 4.0).animate(animationController);

    //   animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var width = 150.0;
    var height = 250.0;

    Widget result = new GestureDetector(
      onTap: widget.onClick,
      child: _clippedNetwork(context, width, height),
    );

    return result;
  }

  Widget _clippedNetwork(
      BuildContext context, double cardwidth, double cardheight) {
    List<Widget> stackChildren = [];

    stackChildren.add(Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            elevation: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              child: Hero(
                tag: imgTag,
                child: CachedNetworkImage(
                  imageUrl: 'https://cdn.bookmeth.com/' + widget.imageUrl,
                  placeholder: (context, url) => Container(
                    height: 130.0,
                    width: 100.0,
                    child: LoadingWidget(
                      isImage: true,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/place.png',
                    fit: BoxFit.scaleDown,
                    height: 130.0,
                    width: 100.0,
                  ),
                  fit: BoxFit.scaleDown,
                  height: 130.0,
                  width: 100.0,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Hero(
            tag: titleTag,
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                '${widget.title}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ]));

    return new Container(
      child: new Align(
          alignment: Alignment.center,
          child: new Stack(children: stackChildren)),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
