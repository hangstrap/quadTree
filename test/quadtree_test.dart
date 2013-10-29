import 'package:quadtree/quadtree.dart';
import 'package:unittest/unittest.dart';
import 'dart:math';

void main(){
  group( "Small tree without children", (){
    
    Rectangle quadTreeSize = new Rectangle(-1, -1, 1, 1);
    QuadTree underTest;
    setUp( () {    
      underTest = new QuadTree( quadTreeSize);     
    });
   
    test( "should create range correctly", (){
      expect( underTest.range, equals( quadTreeSize));
    });
    test( "should add point that is inside range", (){
      QuadTreeLocation inTheCenter = new QuadTreeLocation(new Point( 0, 0));
      underTest.add( inTheCenter );
      expect( underTest.locations, contains( inTheCenter));
    });        
    test( "should not add point that is outside range", (){
      QuadTreeLocation outside = new QuadTreeLocation(new Point( 2, 2));
      underTest.add( outside );
      expect( underTest.locations, isNot( contains( outside)));
    });    

    group( "Single point at the center", (){
      
      QuadTreeLocation inTheCenter;
      setUp(() {
        inTheCenter =  new QuadTreeLocation(new Point( 0, 0));
        underTest.add( inTheCenter );
      });
      test( "when search area equals range should find the point in center", (){
        
        List<QuadTreeLocation> found = [];
        underTest.intersects( quadTreeSize, (e)=> found.add( e));
        expect( found,contains( inTheCenter));
      });
      test( "should not find point when rectangle does not intersect point", (){
        List<QuadTreeLocation> found = [];
        Rectangle onTheSide = new Rectangle( .5, .5, 1, 1);
        underTest.intersects( onTheSide, (e)=> found.add( e));
        expect( found, isNot( contains( inTheCenter)));
      });
      test( "should  find point when rectangle does intersect point", (){
        List<QuadTreeLocation> found = [];
        Rectangle onTheSide = new Rectangle( -.5, -.5, .5, .5);
        underTest.intersects( onTheSide, (e)=> found.add( e));
        expect( found, contains( inTheCenter));
      });
    });
    
    group( "Another class inserted in tree", (){
        test("Use another class that implements the QuadTreeLocation interface", (){
          AnotherLocationClass location  = new AnotherLocationClass()
            ..location = new Point( 0, 0);
          underTest.add( location);
          
          List<AnotherLocationClass> found = [];
          underTest.intersects( quadTreeSize, (e)=> found.add( e));
          expect( found,contains( location));
        });
    });
    
  });
}
class QuadTreeLocation implements Location{
  Point location;
  QuadTreeLocation( this.location);
  Point getLocation(){
    return location;
  }
}
class AnotherLocationClass implements Location{
  Point location;
  Point getLocation(){
    return location;
  }
}