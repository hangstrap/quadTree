library quadtree;

import "dart:math";


class Location{
  Point _point;
  Location( this._point);
  Point getLocation(){
    return _point;
  }
}


class QuadTree{

  List<Location> locations = [];  
  List<QuadTree> childern = [];
  Rectangle range;
  int internalSize;
  
  QuadTree(this.range, [this.internalSize=10]);
  
  void add( Location location){

    if( range.containsPoint( location.getLocation())){
      if( locations.length < internalSize){
        locations.add( location);
      }else{
        if( childern.isEmpty){
          _createChildren();
        }
        childern.forEach( (e)=> e.add( location));
      }
    }
  }
  void intersects( Rectangle rectangle, void f(Location location)){
    
    locations.forEach( (e){
      if( rectangle.containsPoint( e.getLocation())) {
        f(e);
      }   
    });
  }
  
  void _createChildren(){
  
    num midpointX = (range.left + range.right) / 2;
    num midpointY = (range.bottom + range.top) / 2;
    
    Point midPoint = new Point( midpointX, midpointY);
    Point topLeft = range.topLeft;
    Point topRight = range.topRight;
    Point bottomLeft = range.bottomLeft;
    Point bottomRight = range.bottomRight;
    
    
    childern.add(  new QuadTree(  new Rectangle.fromPoints( topLeft, midPoint), internalSize));
    childern.add(  new QuadTree(  new Rectangle.fromPoints( topRight, midPoint), internalSize));
    childern.add(  new QuadTree(  new Rectangle.fromPoints( bottomLeft, midPoint), internalSize));
    childern.add(  new QuadTree(  new Rectangle.fromPoints( bottomRight, midPoint), internalSize));

  }
}