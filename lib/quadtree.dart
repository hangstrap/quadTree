library quadtree;

import "dart:math";
import "dart:async";


class Location{
  Point _point;
  Location( this._point);
  Point getLocation(){
    return _point;
  }
}


class QuadTree<T extends Location>{

  List<T> locations = [];  
  List<QuadTree<T>> childern = [];
  Rectangle range;
  int internalSize;
  
  QuadTree(this.range, [this.internalSize=10]);
  
  bool add( T location){
    
    if( ! range.containsPoint( location.getLocation())){
      return false;
    }
    //is there space in this location list?
    if( locations.length < internalSize){
      locations.add( location);

    }else{
      //Create the children if necesssary
      if( childern.isEmpty){
        _createChildren();
      }
      //Find a child to store the point
      childern.firstWhere( (QuadTree child){ 
        return child.add( location);
      });
    }
 
    return true;
  }
  
  
  void intersects( Rectangle rectangle, void f(T location)){
    
    if( range.intersects( rectangle)){
    
      locations.forEach( (e){
        if( rectangle.containsPoint( e.getLocation())) {
          f(e);
        }   
      });
      
      childern.forEach( (e){e.intersects( rectangle, f);});
    }
  }
  

  
  List<T> intersectionListSync( Rectangle rectangle){
    List<T> found =  [];
    intersects(rectangle, (e)=> found.add( e));
    return found;
  }
  
  Future<List<T>> intersectionList( Rectangle rectangle){
    Completer completer = new Completer();
    completer.complete( intersectionListSync( rectangle));
    return completer.future;
  }
  
  void _createChildren(){
  
    num midpointX = (range.left + range.right) / 2;
    num midpointY = (range.bottom + range.top) / 2;
    
    Point midPoint = new Point( midpointX, midpointY);
    Point topLeft = range.topLeft;
    Point topRight = range.topRight;
    Point bottomLeft = range.bottomLeft;
    Point bottomRight = range.bottomRight;
    
    
    childern.add(  new QuadTree<T>(  new Rectangle.fromPoints( topLeft, midPoint), internalSize));
    childern.add(  new QuadTree<T>(  new Rectangle.fromPoints( topRight, midPoint), internalSize));
    childern.add(  new QuadTree<T>(  new Rectangle.fromPoints( bottomLeft, midPoint), internalSize));
    childern.add(  new QuadTree<T>(  new Rectangle.fromPoints( bottomRight, midPoint), internalSize));

  }
  
}