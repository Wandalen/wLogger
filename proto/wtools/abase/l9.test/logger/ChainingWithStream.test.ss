( function _ChainingWithStream_test_ss_( )
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

const _global = _global_;
const _ = _global_.wTools;
const Parent = wTester;

//

function onSuiteBegin()
{
  let self = this;
  self.testDirPath = _.path.tempOpen( _.path.join( __dirname, '../..'  ), 'ChainingWithStream' )
}

//

function onSuiteEnd()
{
  let self = this;
  _.path.tempClose( self.testDirPath );
}

//

function input( test )
{
  let self = this;
  let con = _.take( null );

  test.open( 'readStream -> multiple printers, chain/unchain in different ways' );

  con
  .then( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let got = [];

    _.fileProvider.fileWrite( filePath, data );
    let readStream = _.fileProvider.streamRead( filePath );

    function onTransformEnd( o )
    {
      got.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd, output : console });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd, output : console });

    printerA.inputFrom( readStream );
    printerB.inputFrom( readStream );

    let expected =
    [
      'printerA : ' + data,
      'printerB : ' + data,
    ];

    return _.time.out( 1000, () =>
    {
      readStream.close();
      test.identical( got, expected );

      let cdPrinterA = printerA.inputs[ 0 ];
      let cdPrinterB = printerB.inputs[ 0 ];
      let onDataListeners = readStream.listeners( 'data' );
      let chainerReadStream = readStream[ Symbol.for( 'chainer' ) ];

      test.true( _.longHas( onDataListeners, cdPrinterA.onDataHandler ) )
      test.true( _.longHas( onDataListeners, cdPrinterB.onDataHandler ) )

      printerA.inputUnchain( readStream );
      printerB.inputUnchain( readStream );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 1 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 1 );

      test.identical( chainerReadStream.inputs.length, 0 );
      test.identical( chainerReadStream.outputs.length, 0 );

      onDataListeners = readStream.listeners( 'data' );
      test.true( !_.longHas( onDataListeners, cdPrinterA.onDataHandler ) );
      test.true( !_.longHas( onDataListeners, cdPrinterB.onDataHandler ) );
      test.identical( onDataListeners.length, 0 );

      return true;
    })
  })

  //

  .then( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let got = [];

    _.fileProvider.fileWrite( filePath, data );
    let readStream = _.fileProvider.streamRead( filePath );

    function onTransformEnd( o )
    {
      got.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd, output : console });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd, output : console });

    printerA.inputFrom( readStream );
    printerB.inputFrom( readStream );

    let expected =
    [
      'printerA : ' + data,
      'printerB : ' + data,
    ];

    return _.time.out( 1000, () =>
    {
      readStream.close();
      test.identical( got, expected );

      let cdPrinterA = printerA.inputs[ 0 ];
      let cdPrinterB = printerB.inputs[ 0 ];
      let onDataListeners = readStream.listeners( 'data' );
      let chainerReadStream = readStream[ Symbol.for( 'chainer' ) ];

      test.true( _.longHas( onDataListeners, cdPrinterA.onDataHandler ) )
      test.true( _.longHas( onDataListeners, cdPrinterB.onDataHandler ) )

      chainerReadStream.outputUnchain( printerA );
      chainerReadStream.outputUnchain( printerB );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 1 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 1 );

      test.identical( chainerReadStream.inputs.length, 0 );
      test.identical( chainerReadStream.outputs.length, 0 );

      onDataListeners = readStream.listeners( 'data' );
      test.true( !_.longHas( onDataListeners, cdPrinterA.onDataHandler ) );
      test.true( !_.longHas( onDataListeners, cdPrinterB.onDataHandler ) );
      test.identical( onDataListeners.length, 0 );

      return true;
    })
  })

  //

  .then( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let got = [];

    _.fileProvider.fileWrite( filePath, data );
    let readStream = _.fileProvider.streamRead( filePath );
    let chainerReadStream = _.Chainer.MakeFor( readStream );

    function onTransformEnd( o )
    {
      got.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd, output : console });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd, output : console });

    chainerReadStream.outputTo( printerA );
    chainerReadStream.outputTo( printerB );

    var expected =
    [
      'printerA : ' + data,
      'printerB : ' + data,
    ];

    return _.time.out( 1000, () =>
    {
      readStream.close();
      test.identical( got, expected );

      let cdPrinterA = printerA.inputs[ 0 ];
      let cdPrinterB = printerB.inputs[ 0 ];
      let onDataListeners = readStream.listeners( 'data' );

      test.true( _.longHas( onDataListeners, cdPrinterA.onDataHandler ) )
      test.true( _.longHas( onDataListeners, cdPrinterB.onDataHandler ) )

      chainerReadStream.outputUnchain( printerA );
      chainerReadStream.outputUnchain( printerB );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 1 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 1 );

      test.identical( chainerReadStream.inputs.length, 0 );
      test.identical( chainerReadStream.outputs.length, 0 );

      onDataListeners = readStream.listeners( 'data' );
      test.true( !_.longHas( onDataListeners, cdPrinterA.onDataHandler ) );
      test.true( !_.longHas( onDataListeners, cdPrinterB.onDataHandler ) );
      test.identical( onDataListeners.length, 0 );

      return true;
    })
  })

  //

  .then( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let got = [];

    _.fileProvider.fileWrite( filePath, data );
    let readStream = _.fileProvider.streamRead( filePath );
    let chainerReadStream = _.Chainer.MakeFor( readStream );

    function onTransformEnd( o )
    {
      got.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd, output : console });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd, output : console });

    chainerReadStream.outputTo( printerA );
    chainerReadStream.outputTo( printerB );

    var expected =
    [
      'printerA : ' + data,
      'printerB : ' + data,
    ];

    return _.time.out( 1000, () =>
    {
      readStream.close();
      test.identical( got, expected );

      let cdPrinterA = printerA.inputs[ 0 ];
      let cdPrinterB = printerB.inputs[ 0 ];
      let onDataListeners = readStream.listeners( 'data' );

      test.true( _.longHas( onDataListeners, cdPrinterA.onDataHandler ) )
      test.true( _.longHas( onDataListeners, cdPrinterB.onDataHandler ) )

      printerA.inputUnchain( readStream );
      printerB.inputUnchain( readStream );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 1 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 1 );

      test.identical( chainerReadStream.inputs.length, 0 );
      test.identical( chainerReadStream.outputs.length, 0 );

      onDataListeners = readStream.listeners( 'data' );
      test.true( !_.longHas( onDataListeners, cdPrinterA.onDataHandler ) );
      test.true( !_.longHas( onDataListeners, cdPrinterB.onDataHandler ) );
      test.identical( onDataListeners.length, 0 );

      return true;
    })
  })

  test.close( 'readStream -> multiple printers, chain/unchain in different ways' );

  return con;
}

input.timeOut = 15000;

//

function output( test )
{
  let self = this;

  let con = _.take( null );

  test.open( 'multiple printers -> writeStream, chain/unchain in different ways' );

  con
  .then( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let expected = [];

    let writeStream = _.fileProvider.streamWrite( filePath );

    function onTransformEnd( o )
    {
      expected.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd, output : console });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd, output : console });

    printerA.outputTo( writeStream );
    printerB.outputTo( writeStream );

    return _.time.out( 1000, () =>
    {
      writeStream.close();

      var file = _.fileProvider.fileRead( filePath );
      test.identical( file, expected.join( '' ) );

      let onDataListeners = writeStream.listeners( 'data' );
      let chainerwriteStream = writeStream[ Symbol.for( 'chainer' ) ];

      test.identical( onDataListeners.length, 0 );

      printerA.outputUnchain( writeStream );
      printerB.outputUnchain( writeStream );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 1 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 1 );

      test.identical( chainerwriteStream.inputs.length, 0 );
      test.identical( chainerwriteStream.outputs.length, 0 );

      onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );

      return true;
    })
  })

  //

  .then( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let expected = [];

    let writeStream = _.fileProvider.streamWrite( filePath );

    function onTransformEnd( o )
    {
      expected.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd, output : console });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd, output : console });

    printerA.outputTo( writeStream );
    printerB.outputTo( writeStream );

    return _.time.out( 1000, () =>
    {
      writeStream.close();

      var file = _.fileProvider.fileRead( filePath );
      test.identical( file, expected.join( '' ) );

      let onDataListeners = writeStream.listeners( 'data' );
      let chainerwriteStream = writeStream[ Symbol.for( 'chainer' ) ];

      test.identical( onDataListeners.length, 0 );

      chainerwriteStream.inputUnchain( printerA );
      chainerwriteStream.inputUnchain( printerB );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 1 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 1 );

      test.identical( chainerwriteStream.inputs.length, 0 );
      test.identical( chainerwriteStream.outputs.length, 0 );

      onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );

      return true;
    })
  })

  //

  .then( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let expected = [];

    let writeStream = _.fileProvider.streamWrite( filePath );
    let chainerWriteStream = _.Chainer.MakeFor( writeStream );

    function onTransformEnd( o )
    {
      expected.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd, output : console });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd, output : console });

    chainerWriteStream.inputFrom( printerA );
    chainerWriteStream.inputFrom( printerB );

    return _.time.out( 1000, () =>
    {
      writeStream.close();

      var file = _.fileProvider.fileRead( filePath );
      test.identical( file, expected.join( '' ) );

      let onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );

      chainerWriteStream.inputUnchain( printerA );
      chainerWriteStream.inputUnchain( printerB );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 1 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 1 );

      test.identical( chainerWriteStream.inputs.length, 0 );
      test.identical( chainerWriteStream.outputs.length, 0 );

      onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );

      return true;
    })
  })

  //

  .then( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let expected = [];

    let writeStream = _.fileProvider.streamWrite( filePath );
    let chainerWriteStream = _.Chainer.MakeFor( writeStream );

    function onTransformEnd( o )
    {
      expected.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd, output : console });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd, output : console });

    chainerWriteStream.inputFrom( printerA );
    chainerWriteStream.inputFrom( printerB );

    return _.time.out( 1000, () =>
    {
      writeStream.close();

      var file = _.fileProvider.fileRead( filePath );
      test.identical( file, expected.join( '' ) );

      let onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );

      printerA.outputUnchain( writeStream );
      printerB.outputUnchain( writeStream );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 1 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 1 );

      test.identical( chainerWriteStream.inputs.length, 0 );
      test.identical( chainerWriteStream.outputs.length, 0 );

      onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );

      return true;
    })
  })

  test.close( 'multiple printers -> writeStream, chain/unchain in different ways' );

  return con;
}

// --
// proto
// --

const Proto =
{

  name : 'Tools.logger.ChainingWithStream',
  silencing : 1,
  enabled : 1,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    testDirPath : null
  },
  tests :
  {
    input,
    output,
  },

};

const Self = wTestSuite( Proto )
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
