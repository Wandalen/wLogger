( function _ChainingWithProcess_test_ss_( )
{

'use strict';

if( typeof module === 'undefined' )
return;

if( typeof module !== 'undefined' )
{
  let _ = require( '../../l9/logger/entry/Logger.s' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );
}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = wTester;

// --
// resource
// --

function testFile()
{

  console.log( 'slave : starting' );
}

//

function onRoutineBegin( test, testFile )
{
  var self = this;
  var c = Object.create( null );
  c.tempDirPath = self.tempDirPath = _.normalize( _.dirTempMake() );
  c.testFilePath = _.normalize( _.join( c.tempDirPath, testFile.name + '.s' ) );
  _.fileProvider.fileWrite( c.testFilePath, _.routineSourceGet({ routine : testFile, withWrap : 0 }) );
  return c;
}

//

function onRoutineEnd( test )
{
  var self = this;
  // _.fileProvider.filesDelete( self.tempDirPath );
}

// --
// test
// --

function trivial( test )
{
  var self = this;
  debugger
  var c = onRoutineBegin.call( this, test, testFile );
  function onWrite( o )
  {
    got.push( o.input[ 0 ] );
  }
  var l = _.Logger({ onWrite, output : null });
  var shell =
  {
    path : c.testFilePath,
    stdio : 'pipe',
    mode : 'spawn',
    outputColoring : 0,
    outputPrefixing : 0,
    ipc : 1,
  }
  var expected = [ 'slave : starting' ];
  var got  = [];
  var result = _.process.startNjs( shell )
  .finally( function( err )
  {
    console.log( 'shellNode : done' );
    if( err )
    _.errLogOnce( err );
    test.description = 'no error from child process throwen';
    test.shouldBe( !err );
    test.shouldBe( _.arraySetIdentical( got, expected ) );
  });

  l.inputFrom( shell.process );
  return result;
}

trivial.timeOut = 30000;

// --
// proto
// --

let Self =
{

  name : 'Tools.logger.ChainingWithProcess',
  silencing : 1,
  enabled : 0,
  onRoutineEnd,
  context :
  {
    tempDirPath : null,
  },
  tests :
  {
    trivial,
  },

};

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
