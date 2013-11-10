import 'package:quadtree/quadtree.dart';
import 'package:unittest/unittest.dart';
import 'dart:math';

class QuadTreeLocation implements Location{
  Point location;
  QuadTreeLocation( num x, num y){
    location = new Point(x, y);
  }
  Point getLocation(){
    return location;
  }
}

void main(){

    
    QuadTree<QuadTreeLocation> underTest;
    Rectangle range = new Rectangle.fromPoints( new Point( 0,0), new Point( 2,4));
    setUp((){
      underTest = new QuadTree<QuadTreeLocation>( range, 1);
    });

    group( "When there not enough locations to create children", (){
      test( "and quad tree is empty, it should not have children",(){
          expect( underTest.childern, isEmpty);      
      });
      test( "when only 1 location has been added the quad tree  should not have children ",(){
        underTest.add( new QuadTreeLocation(0, 0));
        expect( underTest.childern, isEmpty);      
      });
    });
    
    group( "When there are enough locations to create child quadTreese",(){

      QuadTreeLocation firstLocation = new QuadTreeLocation( 1, 1 );
      QuadTreeLocation secondLocation = new QuadTreeLocation( 0.1, 0.1 );

      setUp(() {
        underTest.add( firstLocation);
        underTest.add( secondLocation);        
      });
      
      test( "then chidren should be created", (){
        expect( underTest.childern, isNot( isEmpty));
        expect( underTest.childern.length, 4);
      });
      
      test( "then each child should have an internalSize matching the parent", (){
        expect( underTest.internalSize, 1);
        underTest.childern.forEach( (e) =>expect(e.internalSize, 1));
      });
      
      test( "then the chidren should split the area into four", (){
        
        Point midPoint = new Point( 1, 2);
        
        List<Rectangle> rectangles = [];
        underTest.childern.forEach( (e)=> rectangles.add( e.range));

        expect( rectangles, contains( new Rectangle.fromPoints( range.bottomLeft, midPoint)));
        expect( rectangles, contains( new Rectangle.fromPoints( range.bottomRight, midPoint)));
        expect( rectangles, contains( new Rectangle.fromPoints( range.topLeft, midPoint)));
        expect( rectangles, contains(new Rectangle.fromPoints( range.topLeft, midPoint)));

      });
      
      test( "The parent should still have only the firstPoint stored in it", (){
          expect( underTest.locations.length, 1);
          expect( underTest.locations, contains( firstLocation));          
      });
      
      test( "The child that the secondPoint intersects should have stored the location", (){
        var count = 0;
          underTest.childern.forEach( (QuadTree child){
            if( child.range.containsPoint( secondLocation.getLocation())){
              expect( child.locations, contains( secondLocation));     
              count++;
            }
          });
          expect( count, 1);    
      });
    });

    group( "When the location is on the edge of the internal rectangles", (){
      test( "the location should only be added to one child", (){
        
        QuadTreeLocation firstLocation = new QuadTreeLocation( 1, 1 );
        QuadTreeLocation locationAtMidPoint = new QuadTreeLocation(1, 2);
        underTest.add( firstLocation);
        underTest.add( locationAtMidPoint);
        
        var count = 0;
        underTest.childern.forEach( (QuadTree child){
            if( child.locations.contains( locationAtMidPoint)){   
              count++;
            }
        });
        expect( count, 1);    

      });
    });

    group( "When you itterate with an rectangle ", (){
      
      var bottomLeft = new QuadTreeLocation(0, 0);
      var topRight = new QuadTreeLocation(2, 4);
      var midPoint = new QuadTreeLocation(1, 2);      

      setUp((){
        underTest = new QuadTree( range, 1);
        underTest.add( bottomLeft);      
        underTest.add( topRight); 
        underTest.add( midPoint);
      });
     
      
      test("equal to the entire range then should return all points", (){
        checkIntersectionHas(underTest, range, [ bottomLeft, topRight, midPoint]);
      });
      
      test("equal to the just the centre then should return just the center points", (){
        var rectangleAroundCenter = new Rectangle.fromPoints(new Point( .9, 1.8), new Point( 1.1, 2.1));
        expect( rectangleAroundCenter.containsPoint( midPoint.getLocation()), isTrue);
        checkIntersectionHas( underTest, rectangleAroundCenter, [midPoint]);
      });

    });
    
}
void checkIntersectionHas( QuadTree underTest, Rectangle area, List<QuadTreeLocation> expectedLocations){

  int found =0;
  underTest.intersects( area, (QuadTreeLocation e){
    found++;
    expect( expectedLocations, contains( e));
  });
  //Lengths must match
  expect( found, expectedLocations.length);
}
