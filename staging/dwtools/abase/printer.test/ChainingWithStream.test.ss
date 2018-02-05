( function _ChainingWithStream_test_ss( ) {

'use strict';

if( typeof module === 'undefined' )
return;

if( typeof module !== 'undefined' )
{

  require( '../printer/top/Logger.s' );

  var _ = _global_.wTools;

  _.include( 'wTesting' );
  _.include( 'wFiles' );
  _.include( 'wPath' );

}

//

var _ = _global_.wTools;
var Parent = _.Tester;

function testDirMake()
{
  var self = this;
  self.testDirPath = _.dirTempMake();
}

//

function testDirClean()
{
  var self = this;
  _.fileProvider.filesDelete( self.testDirPath );
}

//

function readFromFile( test )
{
  var self = this;

  var filePath = _.pathJoin( self.testDirPath, 'file.txt' )

  var data = _.strDup( '1', 10 );
  var got = [];
  var expected = [ data ];

  _.fileProvider.fileWrite( filePath, data );
  var readStream = _.fileProvider.fileReadStream( filePath );

  function onWrite( o )
  {
    got.push( o.input[ 0 ] );
  }

  var l = new _.Logger
  ({
    output : null,
    onWrite : onWrite
  });
  l.inputFrom( readStream );

  return _.timeOut( 1000, () =>
  {
    readStream.close();
    test.identical( got, expected );
  })

}

//

function writeToFile( test )
{
  var self = this;

  var filePath = _.pathJoin( self.testDirPath, 'file.txt' )

  var writeStream = _.fileProvider.fileWriteStream( filePath );

  var data = _.strDup( '1', 10 );
  var expected = [];

  function onWrite( o )
  {
    expected.push( o.input[ 0 ] );
  }

  var l = new _.Logger
  ({
    output : null,
    onWrite : onWrite
  });

  l.outputTo( writeStream );

  l.log( '1' );
  l.log( '2' );
  l.log( '3' );

  return _.timeOut( 1000, () =>
  {
    writeStream.close();
    var file = _.fileProvider.fileRead( filePath );
    test.identical( file, expected.join( '' ) );
  })
}

// --
// proto
// --

var Self =
{

  name : 'ChainingWithStream',
  silencing : 1,

  onSuitBegin : testDirMake,
  onSuitEnd : testDirClean,

  context :
  {
    testDirPath : null
  },
  tests :
  {
    readFromFile : readFromFile,
    writeToFile : writeToFile,
  },

};

Self = wTestSuit( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();