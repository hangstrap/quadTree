import 'package:quadtree/quadtree.dart';
import 'package:unittest/unittest.dart';   
import 'dart:math';
import "dart:async";

void main(){
  group( "Small tree without children", (){
    Point p1  = new Point(-1, -1);
    Point p2 = new Point(1, 1);
    Rectangle quadTreeSize = new Rectangle.fromPoints(p2, p1);

    QuadTree<Location> underTest;
    setUp( () {    
      underTest = new QuadTree<Location>( quadTreeSize);     
    });
   
    test( "should create range correctly", (){
      expect( underTest.range, equals( quadTreeSize));
      expect( underTest.range.bottom, 1);
      expect( underTest.range.left, -1);
      expect( underTest.range.top, -1);
      expect( underTest.range.right, 1);
    });
    test( "should add point that is inside range", (){
      Location inTheCenter = new Location(new Point( 0, 0));
      expect( underTest.add( inTheCenter ), true);
      expect( underTest.locations, contains( inTheCenter));
    });        
    test( "should not add point that is outside range", (){
      Location outside = new Location(new Point( 2, 2));
      expect( underTest.add( outside ), false);
      expect( underTest.locations, isNot( contains( outside)));
    });    

    group( "Single point at the center", (){
      
      Location inTheCenter;
      setUp(() {
        inTheCenter =  new Location(new Point( 0, 0));
        underTest.add( inTheCenter );
      });
      group( "when search area equals range should find the point in center", (){
        
        List<Location> found = [];
        test( "when called via intersect", (){
          underTest.intersects( quadTreeSize, (e)=> found.add( e));
          expect( found, contains( inTheCenter));
        });
        test( "when called vaid intersectListSync", (){
          //now check the list
          List<Location> list=  underTest.intersectionListSync( quadTreeSize);
          expect( list, contains( inTheCenter));
        });
        test( "when called vaid intersectListFuture", (){        
          //Now do it with a future
          Future<  List<Location>> future =   underTest.intersectionList( quadTreeSize);
          expect( future.then( (list)=> list.contains( inTheCenter)), completion( equals( true)));
        });
      });
      
      
      
      test( "should not find point when rectangle does not intersect point", (){
        List<Location> found = [];
        Rectangle onTheSide = new Rectangle( .5, .5, 1, 1);
        underTest.intersects( onTheSide, (e)=> found.add( e));
        expect( found, isNot( contains( inTheCenter)));
      });
      test( "should  find point when rectangle does intersect point", (){
        List<Location> found = [];
        Rectangle onTheSide = new Rectangle( -.5, -.5, .5, .5);
        underTest.intersects( onTheSide, (e)=> found.add( e));
        expect( found, contains( inTheCenter));
      });
    });
    
    group( "Another class inserted in tree", (){
        test("Use another class that implements the Location interface", (){
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

class AnotherLocationClass implements Location{
  Point location;
  Point getLocation(){
    return location;
  }
}