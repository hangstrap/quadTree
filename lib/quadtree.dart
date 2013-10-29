library quadtree;

import "dart:math";


abstract class Location{
  Point getLocation();
//  Point point;
//  
//  QuadTreeLocation( this.point);
//  Point getLocation(){
//    return point;
//  }
}


class QuadTree{

  List<Location> locations = [];  
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