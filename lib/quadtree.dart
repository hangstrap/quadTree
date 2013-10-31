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
  List<QuadTree> children =[];
  Rectangle range;
  int internalSize;
  
  QuadTree(this.range, [this.internalSize=10]);
  
  void add( Location location){

    if( range.containsPoint( location.getLocation())){
      locations.add( location);
    }
  }
  void intersects( Rectangle rectangle, void f(Location location)){
    
    locations.forEach( (e){
      if( rectangle.containsPoint( e.getLocation())) {
        f(e);
      }   
    });
  }
  
}