library quadtree;

import "dart:math";


class QuadTreeLocation{

  Point point;
  
  QuadTreeLocation( this.point);
  Point getLocation(){
    return point;
  }
}


class QuadTree{

  List<QuadTreeLocation> locations = [];  
  Rectangle range;
  int internalSize;
  
  QuadTree(this.range, [this.internalSize=10]);
  
  void add( QuadTreeLocation location){

    if( range.containsPoint( location.getLocation())){
      locations.add( location);
    }
  }
  void intersects( Rectangle rectangle, void f(QuadTreeLocation location)){
    
    locations.forEach( (e){
      if( rectangle.containsPoint( e.getLocation())) {
        f(e);
      }   
    });
  }
  
}