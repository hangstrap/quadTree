import 'package:quadtree/quadtree.dart';
import 'package:unittest/unittest.dart';
import 'dart:math';

class QuadTreeLocation implements Location{
  Point location;
  QuadTreeLocation( int x, int y){
    location = new Point(x, y);
  }
  Point getLocation(){
    return location;
  }
}

void main(){
  group( "When internal size is 1",(){
    
    QuadTree underTest;
    Rectangle range = new Rectangle.fromPoints( new Point( 0,0), new Point( 2,4));
    setUp((){
      underTest = new QuadTree( range, 1);
    });
    group( "and there are not enough locations to create children", (){
      test( "quad tree should not have children when no locations",(){
          expect( underTest.childern, isEmpty);      
      });
      test( "quad tree should not have children when only 1 locations",(){
        underTest.add( new QuadTreeLocation( 0, 0 ));
        expect( underTest.childern, isEmpty);      
      });
    });
    group( "and there are enough locations to create children",(){
      
      setUp(() {
        underTest.add( new QuadTreeLocation( 1, 1 ));
        underTest.add( new QuadTreeLocation( 1, 2));        
      });
      test( "then chidren should be created", (){
        expect( underTest.childern, isNot( isEmpty));
        expect( underTest.childern.length, 4);
      });
      test( "then each child should have an internalSize matching the parent", (){
        expect( underTest.internalSize, 1);
        underTest.childern.forEach( (e) =>expect(e.internalSize, 1));
      });
      test( "then chidren should split the area into four", (){
        
        Point midPoint = new Point( 1, 2);
        
        List<Rectangle> rectangles = [];
        underTest.childern.forEach( (e)=> rectangles.add( e.range));

        expect( rectangles, contains( new Rectangle.fromPoints( range.bottomLeft, midPoint)));
        expect( rectangles, contains( new Rectangle.fromPoints( range.bottomRight, midPoint)));
        expect( rectangles, contains( new Rectangle.fromPoints( range.topLeft, midPoint)));
        expect( rectangles, contains(new Rectangle.fromPoints( range.topLeft, midPoint)));

      });
 

    });
  });
  
}