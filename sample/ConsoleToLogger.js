

if( typeof module !== 'undefined' )
require( '../staging/abase/object/printer/printer/Logger.s' );

var _ = wTools;

var b = new wLogger();
b._prefix = '*'
b.inputFrom( console )
b.log('1');
console.log('2')
console.log( b.inputs[0].input === b.outputs[0].output )
