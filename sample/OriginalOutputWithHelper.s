
/* qqq : make it nicer */

if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

let outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformBegin : onTransformBegin });
let barPrinter = new _.Logger({ name : 'barPrinter', onTransformBegin : onTransformBegin });

var bar = _.Logger.ConsoleBar
({
  outputPrinter : outputPrinter,
  barPrinter : barPrinter,
});

console.log( 'console.log - #1' );
outputPrinter.log( 'outputPrinter.log - #1' );

bar.on = 0;
_.Logger.ConsoleBar( bar )

console.log( 'console.log - #2' );
outputPrinter.log( 'outputPrinter.log - #2' );

function onTransformBegin( o )
{
  o.input[ 0 ] = this.name +  ' : ' + o.input[ 0 ];
  return o;
}
