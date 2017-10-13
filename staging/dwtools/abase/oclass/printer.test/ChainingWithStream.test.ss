( function _ChainingWithStream_test_ss( ) {

'use strict';

if( typeof module === 'undefined' )
return;

if( typeof module !== 'undefined' )
{
  try
  {
   require( '../../Base.s' );
  }
  catch( err )
  {
   require( 'wTools' );
  }
  var _ = wTools;
  _.include( 'wTesting' );

}

var _ = wTools;

function testDirMake()
{
  this.testDirPath = _.pathRegularize( _.dirTempMake() );
}

//

function testDirClean()
{
  _.fileProvider.fileDelete( this.testDirPath );
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
  var readStream = _.fileProvider.createReadStreamAct( filePath );

  function onWrite( o )
  {
    got.push( o.input[ 0 ] );
  }

  var l = new wLogger
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

  var writeStream = _.fileProvider.createWriteStreamAct( filePath );

  var data = _.strDup( '1', 10 );
  var expected = [];

  function onWrite( o )
  {
    expected.push( o.input[ 0 ] );
  }

  var l = new wLogger
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

  onSuiteBegin : testDirMake,
  onSuiteEnd : testDirClean,

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

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();