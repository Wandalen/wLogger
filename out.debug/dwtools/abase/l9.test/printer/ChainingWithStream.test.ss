( function _ChainingWithStream_test_ss_( ) {

'use strict';

if( typeof module === 'undefined' )
return;

if( typeof module !== 'undefined' )
{

  require( '../../l9/printer/top/Logger.s' );

  let _ = _global_.wTools;

  _.include( 'wTesting' );
  _.include( 'wFiles' );
  _.include( 'wPathFundamentals' );
}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = _.Tester;

//

function onSuiteBegin()
{
  let self = this;
  self.testDirPath = _.path.dirTempMake();
}

//

function onSuiteEnd()
{
  let self = this;
  _.fileProvider.filesDelete( self.testDirPath );
}

//

function input( test )
{
  let self = this;

  let con = new _.Consequence().give()

  test.open( 'readStream -> multiple printers, chain/unchain in different ways' );

  con
  .ifNoErrorThen( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let got = [];

    _.fileProvider.fileWrite( filePath, data );
    let readStream = _.fileProvider.fileReadStream( filePath );

    function onTransformEnd( o )
    {
      got.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd : onTransformEnd });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd : onTransformEnd });

    printerA.inputFrom( readStream );
    printerB.inputFrom( readStream );

    let expected =
    [
      'printerA : ' + data,
      'printerB : ' + data,
    ];

    return _.timeOut( 1000, () =>
    {
      readStream.close();
      test.identical( got, expected );

      let cdPrinterA = printerA.inputs[ 0 ];
      let cdPrinterB = printerB.inputs[ 0 ];
      let onDataListeners = readStream.listeners( 'data' );
      let chainerReadStream = readStream[ Symbol.for( 'chainer' ) ];

      test.is( _.arrayHas( onDataListeners, cdPrinterA.onDataHandler ) )
      test.is( _.arrayHas( onDataListeners, cdPrinterB.onDataHandler ) )

      printerA.inputUnchain( readStream );
      printerB.inputUnchain( readStream );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 0 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 0 );

      test.identical( chainerReadStream.inputs.length, 0 );
      test.identical( chainerReadStream.outputs.length, 0 );

      onDataListeners = readStream.listeners( 'data' );
      test.is( !_.arrayHas( onDataListeners, cdPrinterA.onDataHandler ) );
      test.is( !_.arrayHas( onDataListeners, cdPrinterB.onDataHandler ) );
      test.identical( onDataListeners.length, 0 );
    })
  })

  //

  .ifNoErrorThen( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let got = [];

    _.fileProvider.fileWrite( filePath, data );
    let readStream = _.fileProvider.fileReadStream( filePath );

    function onTransformEnd( o )
    {
      got.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd : onTransformEnd });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd : onTransformEnd });

    printerA.inputFrom( readStream );
    printerB.inputFrom( readStream );

    let expected =
    [
      'printerA : ' + data,
      'printerB : ' + data,
    ];

    return _.timeOut( 1000, () =>
    {
      readStream.close();
      test.identical( got, expected );

      let cdPrinterA = printerA.inputs[ 0 ];
      let cdPrinterB = printerB.inputs[ 0 ];
      let onDataListeners = readStream.listeners( 'data' );
      let chainerReadStream = readStream[ Symbol.for( 'chainer' ) ];

      test.is( _.arrayHas( onDataListeners, cdPrinterA.onDataHandler ) )
      test.is( _.arrayHas( onDataListeners, cdPrinterB.onDataHandler ) )

      chainerReadStream.outputUnchain( printerA );
      chainerReadStream.outputUnchain( printerB );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 0 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 0 );

      test.identical( chainerReadStream.inputs.length, 0 );
      test.identical( chainerReadStream.outputs.length, 0 );

      onDataListeners = readStream.listeners( 'data' );
      test.is( !_.arrayHas( onDataListeners, cdPrinterA.onDataHandler ) );
      test.is( !_.arrayHas( onDataListeners, cdPrinterB.onDataHandler ) );
      test.identical( onDataListeners.length, 0 );
    })
  })

  //

  .ifNoErrorThen( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let got = [];

    _.fileProvider.fileWrite( filePath, data );
    let readStream = _.fileProvider.fileReadStream( filePath );
    let chainerReadStream = _.Chainer.MakeFor( readStream );

    function onTransformEnd( o )
    {
      got.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd : onTransformEnd });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd : onTransformEnd });

    chainerReadStream.outputTo( printerA );
    chainerReadStream.outputTo( printerB );

    var expected =
    [
      'printerA : ' + data,
      'printerB : ' + data,
    ];

    return _.timeOut( 1000, () =>
    {
      readStream.close();
      test.identical( got, expected );

      let cdPrinterA = printerA.inputs[ 0 ];
      let cdPrinterB = printerB.inputs[ 0 ];
      let onDataListeners = readStream.listeners( 'data' );

      test.is( _.arrayHas( onDataListeners, cdPrinterA.onDataHandler ) )
      test.is( _.arrayHas( onDataListeners, cdPrinterB.onDataHandler ) )

      chainerReadStream.outputUnchain( printerA );
      chainerReadStream.outputUnchain( printerB );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 0 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 0 );

      test.identical( chainerReadStream.inputs.length, 0 );
      test.identical( chainerReadStream.outputs.length, 0 );

      onDataListeners = readStream.listeners( 'data' );
      test.is( !_.arrayHas( onDataListeners, cdPrinterA.onDataHandler ) );
      test.is( !_.arrayHas( onDataListeners, cdPrinterB.onDataHandler ) );
      test.identical( onDataListeners.length, 0 );
    })
  })

  //

  .ifNoErrorThen( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let got = [];

    _.fileProvider.fileWrite( filePath, data );
    let readStream = _.fileProvider.fileReadStream( filePath );
    let chainerReadStream = _.Chainer.MakeFor( readStream );

    function onTransformEnd( o )
    {
      got.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd : onTransformEnd });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd : onTransformEnd });

    chainerReadStream.outputTo( printerA );
    chainerReadStream.outputTo( printerB );

    var expected =
    [
      'printerA : ' + data,
      'printerB : ' + data,
    ];

    return _.timeOut( 1000, () =>
    {
      readStream.close();
      test.identical( got, expected );

      let cdPrinterA = printerA.inputs[ 0 ];
      let cdPrinterB = printerB.inputs[ 0 ];
      let onDataListeners = readStream.listeners( 'data' );

      test.is( _.arrayHas( onDataListeners, cdPrinterA.onDataHandler ) )
      test.is( _.arrayHas( onDataListeners, cdPrinterB.onDataHandler ) )

      printerA.inputUnchain( readStream );
      printerB.inputUnchain( readStream );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 0 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 0 );

      test.identical( chainerReadStream.inputs.length, 0 );
      test.identical( chainerReadStream.outputs.length, 0 );

      onDataListeners = readStream.listeners( 'data' );
      test.is( !_.arrayHas( onDataListeners, cdPrinterA.onDataHandler ) );
      test.is( !_.arrayHas( onDataListeners, cdPrinterB.onDataHandler ) );
      test.identical( onDataListeners.length, 0 );
    })
  })

  test.close( 'readStream -> multiple printers, chain/unchain in different ways' );

  return con;
}

//

function output( test )
{
  let self = this;

  let con = new _.Consequence().give()

  test.open( 'multiple printers -> writeStream, chain/unchain in different ways' );

  con
  .ifNoErrorThen( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let expected = [];

    let writeStream = _.fileProvider.fileWriteStream( filePath );

    function onTransformEnd( o )
    {
      expected.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd : onTransformEnd });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd : onTransformEnd });

    printerA.outputTo( writeStream );
    printerB.outputTo( writeStream );

    return _.timeOut( 1000, () =>
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
      test.identical( printerA.outputs.length, 0 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 0 );

      test.identical( chainerwriteStream.inputs.length, 0 );
      test.identical( chainerwriteStream.outputs.length, 0 );

      onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );
    })
  })

  //

  .ifNoErrorThen( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let expected = [];

    let writeStream = _.fileProvider.fileWriteStream( filePath );

    function onTransformEnd( o )
    {
      expected.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd : onTransformEnd });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd : onTransformEnd });

    printerA.outputTo( writeStream );
    printerB.outputTo( writeStream );

    return _.timeOut( 1000, () =>
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
      test.identical( printerA.outputs.length, 0 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 0 );

      test.identical( chainerwriteStream.inputs.length, 0 );
      test.identical( chainerwriteStream.outputs.length, 0 );

      onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );
    })
  })

  //

  .ifNoErrorThen( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let expected = [];

    let writeStream = _.fileProvider.fileWriteStream( filePath );
    let chainerWriteStream = _.Chainer.MakeFor( writeStream );

    function onTransformEnd( o )
    {
      expected.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd : onTransformEnd });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd : onTransformEnd });

    chainerWriteStream.inputFrom( printerA );
    chainerWriteStream.inputFrom( printerB );

    return _.timeOut( 1000, () =>
    {
      writeStream.close();

      var file = _.fileProvider.fileRead( filePath );
      test.identical( file, expected.join( '' ) );

      let onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );

      chainerWriteStream.inputUnchain( printerA );
      chainerWriteStream.inputUnchain( printerB );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 0 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 0 );

      test.identical( chainerWriteStream.inputs.length, 0 );
      test.identical( chainerWriteStream.outputs.length, 0 );

      onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );
    })
  })

  //

  .ifNoErrorThen( () =>
  {
    let filePath = _.path.join( self.testDirPath, 'file.txt' )

    let data = _.strDup( '1', 10 );
    let expected = [];

    let writeStream = _.fileProvider.fileWriteStream( filePath );
    let chainerWriteStream = _.Chainer.MakeFor( writeStream );

    function onTransformEnd( o )
    {
      expected.push( this.name + ' : ' + o.input[ 0 ] );
    }

    let printerA = new _.Logger({ name : 'printerA', onTransformEnd : onTransformEnd });
    let printerB = new _.Logger({ name : 'printerB', onTransformEnd : onTransformEnd });

    chainerWriteStream.inputFrom( printerA );
    chainerWriteStream.inputFrom( printerB );

    return _.timeOut( 1000, () =>
    {
      writeStream.close();

      var file = _.fileProvider.fileRead( filePath );
      test.identical( file, expected.join( '' ) );

      let onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );

      printerA.outputUnchain( writeStream );
      printerB.outputUnchain( writeStream );

      test.identical( printerA.inputs.length, 0 );
      test.identical( printerA.outputs.length, 0 );

      test.identical( printerB.inputs.length, 0 );
      test.identical( printerB.outputs.length, 0 );

      test.identical( chainerWriteStream.inputs.length, 0 );
      test.identical( chainerWriteStream.outputs.length, 0 );

      onDataListeners = writeStream.listeners( 'data' );
      test.identical( onDataListeners.length, 0 );
    })
  })

  test.close( 'multiple printers -> writeStream, chain/unchain in different ways' );

  return con;
}

// --
// proto
// --

var Self =
{

  name : 'ChainingWithStream',
  silencing : 1,
  enabled : 1,

  onSuiteBegin : onSuiteBegin,
  onSuiteEnd : onSuiteEnd,

  context :
  {
    testDirPath : null
  },
  tests :
  {
    input : input,
    output : output,
  },

};

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
