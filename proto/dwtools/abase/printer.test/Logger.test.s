( function _Logger_test_ss_( ) {

'use strict';

/* aaa */

if( typeof module !== 'undefined' )
{

  require( '../printer/top/Logger.s' );

  var _global = _global_; var _ = _global_.wTools;

  _.include( 'wTesting' );

}

//

var _global = _global_; var _ = _global_.wTools;
var Parent = _.Tester;

//

function clone( test )
{
  test.case = 'clone printer';

  var printer = new _.Logger({ name : 'printerA', onTransformEnd : onTransformEnd });
  var inputPrinter = new _.Logger({ name : 'inputPrinter', onTransformEnd : onTransformEnd });
  var outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformEnd : onTransformEnd });

  printer.outputTo( outputPrinter );
  printer.inputFrom( inputPrinter );

  var clonedPrinter =  printer.clone();

  clonedPrinter.name = 'clonedPrinter';

  test.will = 'printers must have same inputs/outputs'

  test.identical( printer.inputs.length, 1 );
  test.identical( printer.outputs.length, 1 );

  test.identical( clonedPrinter.inputs.length, 1 );
  test.identical( clonedPrinter.outputs.length, 1 );

  test.identical( outputPrinter.inputs.length, 2 );
  test.identical( outputPrinter.inputs[ 0 ].inputPrinter , printer );
  test.identical( outputPrinter.inputs[ 1 ].inputPrinter , clonedPrinter );

  test.identical( inputPrinter.outputs.length, 2 );
  test.identical( inputPrinter.outputs[ 0 ].outputPrinter , printer );
  test.identical( inputPrinter.outputs[ 1 ].outputPrinter , clonedPrinter );

  test.identical( printer.inputs[ 0 ].inputPrinter , clonedPrinter.inputs[ 0 ].inputPrinter );
  test.identical( printer.outputs[ 0 ].outputPrinter , clonedPrinter.outputs[ 0 ].outputPrinter );

  var hooked = [];
  var expected =
  [
    'inputPrinter : for printers',

    'printerA : for printers',
    'outputPrinter : for printers',

    'clonedPrinter : for printers',
    'outputPrinter : for printers'
  ]

  inputPrinter.log( 'for printers' );

  test.identical( hooked, expected );

  function onTransformEnd( o )
  {
    hooked.push( this.name + ' : ' + o.input[ 0 ] );
    return o;
  }

}

//

var Self =
{

  name : 'Tools/base/printer/Logger',
  silencing : 1,

  tests :
  {
    clone : clone,
  },

}

//

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
