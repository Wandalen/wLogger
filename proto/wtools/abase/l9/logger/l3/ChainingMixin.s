(function _aChainingMixin_s_()
{

'use strict';

/* principles :

  Printer could input / output from / to non-printer objects.
  Doing that printer preserves all fields of the object, but "chainerSymbol" field which got reference on chain decriptor.
  Printer does not write / rewrite any fields of destination / source object, but "chainerSymbol" field.

*/

/**
 * @classdesc Extends printer with mechanism of message transfering between multiple inputs/outputs.
 * @class wPrinterChainingMixin
 * @namespace Tools
 * @module Tools/base/Logger
 */

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = wPrinterChainingMixin;
function wPrinterChainingMixin( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PrinterChainingMixin';

//

function onMixinEnd( mixinDescriptor, dstClass )
{
  let dstPrototype = dstClass.prototype;

  _.assert( dstPrototype._writeToChannelWithoutExclusion === _writeToChannelWithoutExclusion );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.routineIs( dstClass ) );
  _.assert( _.routineIs( dstClass ) );

  dstPrototype._initChainingMixin( mixinDescriptor );

  _.assert( _.routineIs( Self.prototype._writeAct ) );
  _.assert( dstPrototype._writeAct === Self.prototype._writeAct );

}

//

function _initChainingMixin( mixinDescriptor )
{
  let proto = this;

  _.assert( Object.hasOwnProperty.call( proto, 'constructor' ) );

  proto.Channel.forEach( ( channel, c ) =>
  {
    proto._initChainingMixinChannel( mixinDescriptor, channel );
  });

}

//

function _initChainingMixinChannel( mixinDescriptor, channel )
{
  let proto = this;

  _.assert( Object.hasOwnProperty.call( proto, 'constructor' ) )
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( channel ) );

  // if( proto[ channel ] )
  // return;

  /* */

  proto[ channel ] = write;
  proto[ channel + 'Up' ] = writeUp;
  proto[ channel + 'Down' ] = writeDown;
  proto[ channel + 'In' ] = writeIn;

  /* */

  function write()
  {
    this._writeAct( channel, arguments );
    // this._writeAct( channel, _.longSlice( arguments ) ); /* yyy */
    return this;
  }

  /* */

  function writeUp()
  {
    this._writeToChannelUp( channel, arguments );
    return this;
  }

  /* */

  function writeDown()
  {
    this._writeToChannelDown( channel, arguments );
    return this;
  }

  /* */

  function writeIn()
  {
    this._writeToChannelIn( channel, arguments );
    return this;
  }

}

//

function init( original )
{

  return function init()
  {
    let self = this;

    self[ chainerSymbol ] = self._chainerMakeFor( self );

    let result = original.apply( self, arguments );

    return result;
  }

}

//

function finit( original )
{

  return function finit()
  {
    let self = this;

    // debugger; xxx
    self.chainer.finit();

    let result = original.apply( self, arguments );

    return result;
  }

}

// --
// write
// --

function _writeAct( channelName, args )
{
  let self = this;
  let inputChainer = self[ chainerSymbol ];

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( channelName ) );
  _.assert( _.longIs( args ) );

  if( inputChainer.exclusiveOutputPrinter )
  {
    inputChainer.exclusiveOutputPrinter[ channelName ].apply( inputChainer.exclusiveOutputPrinter, args );
    return;
  }

  return self._writeToChannelWithoutExclusion( channelName, args );
}

//

function _writeToChannelWithoutExclusion( channelName, args )
{
  let self = this;
  let inputChainer = self[ chainerSymbol ];

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( channelName ) );
  _.assert( _.longIs( args ) );

  // debugger;
  args = _.filter( args, ( a ) => a ); // yyy
  if( !args.length ) // yyy
  return; // yyy

  let o = self.transform({ input : args, channelName });

  if( !o )
  return;

  self.outputs.forEach( ( cd ) =>
  {
    let outputChainer = cd.outputPrinter[ chainerSymbol ];
    let outputData = cd.outputPrinter.isPrinter ? o.outputForPrinter : o.outputForTerminal;

    _.assert( _.longIs( outputData ) );

    if( cd.originalOutput )
    {
      return outputChainer.originalWrite[ channelName ].apply( cd.outputPrinter, outputData );
    }

    if( cd.write && cd.write[ channelName ] )
    {
      cd.write[ channelName ].apply( cd.outputPrinter, outputData );
    }
    else
    {
      _.assert( _.routineIs( cd.outputPrinter[ channelName ] ) );
      cd.outputPrinter[ channelName ].apply( cd.outputPrinter, outputData );
    }

  });

  return o;
}

//

function write()
{
  let self = this;

  self._writeAct( channelName, arguments );

  return self;
}

//

function _writeToChannelUp( channelName, args )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( channelName ) );
  _.assert( _.longIs( args ) );

  self.up();

  self.begin( 'head' );
  self._writeAct( channelName, args );
  self.end( 'head' );

}

//

function _writeToChannelDown( channelName, args )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( channelName ) );
  _.assert( _.longIs( args ) );

  self.begin( 'tail' );
  self._writeAct( channelName, args );
  self.end( 'tail' );

  self.down();

}

//

function _writeToChannelIn( channelName, args )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( channelName ) );
  _.assert( _.longIs( args ) );
  _.assert( args.length === 2 );
  _.assert( _.strIs( args[ 0 ] ) );

  let tag = Object.create( null );
  tag[ args[ 0 ] ] = args[ 1 ];

  self.begin( tag );
  self._writeAct( channelName, [ args[ 1 ] ] );
  self.end( tag );

}

// --
//
// --

/**
 * Adds new logger( output ) to output list.
 *
 * Each message from current logger will be transfered
 * to each logger from that list. Supports several combining modes: 0, rewrite, supplement, append, prepend.
 * If output already exists in the list and combining mode is not 'rewrite'.
 * @returns True if new output is succesfully added, otherwise return false if output already exists and combining mode is not 'rewrite'
 * or if list is not empty and combining mode is 'supplement'.
 *
 * @param { Object } output - Logger that must be added to list.
 * @param { Object } o - Options.
 * @param { Object } [ o.leveling=null ] - Controls logger leveling mode: 0, false or '' - logger uses it own leveling methods,
 * 'delta' -  chains together logger and output leveling methods.
 * @param { Object } [ o.combining=null ] - Mode which controls how new output appears in list:
 *  0, false or '' - combining is disabled;
 * 'rewrite' - clears list before adding new output;
 * 'append' - adds output to the end of list;
 * 'prepend' - adds output at the beginning;
 * 'supplement' - adds output if list is empty.
 *
 * @example
 * let l = new _.Logger({ output : console });
 * l.outputTo( logger, { combining : 'rewrite' } ); //returns true
 * logger._prefix = '--';
 * l.log( 'abc' );//logger prints '--abc'
 *
 * @example
 * let l1 = new _.Logger({ output : console });
 * let l2 = new _.Logger({ output : console });
 * l1.outputTo( logger, { combining : 'rewrite' } );
 * l2.outputTo( l1, { combining : 'rewrite' } );
 * logger._prefix = '*';
 * logger._postfix = '*';
 * l2.log( 'msg from l2' );//logger prints '*msg from l2*'
 *
 * @example
 * let l1 = new _.Logger({ output : console });
 * let l2 = new _.Logger({ output : console });
 * let l3 = new _.Logger({ output : console });
 * logger.outputTo( l1, { combining : 'rewrite' } );
 * logger.outputTo( l2, { combining : 'append' } );
 * logger.outputTo( l3, { combining : 'append' } );
 * l1._prefix = '*';
 * l2._prefix = '**';
 * l3._prefix = '***';
 * logger.log( 'msg from logger' );
 * //l1 prints '*msg from logger'
 * //l2 prints '**msg from logger'
 * //l3 prints '***msg from logger'
 *
 * @example
 * let l1 = new _.Logger({ output : console });
 * l.outputTo( logger, { combining : 'rewrite', leveling : 'delta' } );
 * logger.up( 2 );
 * l.up( 1 );
 * logger.log( 'aa\nb' );
 * l.log( 'c\nd' );
 * //logger prints
 * // ---aa
 * // ---b
 * // ----c
 * // -----d
 *
 * @method outputTo
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( output ) is not a Object or null.
 * @throws { Exception } If specified combining mode is not allowed.
 * @throws { Exception } If specified leveling mode is not allowed.
 * @throws { Exception } If combining mode is disabled and output list has multiple elements.
 * @class wPrinterChainingMixin
 * @namespace Tools
 * @module Tools/base/Logger
 *
 */

function outputTo( output, o )
{
  let self = this;
  // let chainer = self[ chainerSymbol ];

  o = _.routineOptions( self.outputTo, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  let o2 = _.mapExtend( null, o );
  o2.inputPrinter = self;
  o2.outputPrinter = output;
  o2.inputCombining = o.combining;
  // o2.outputCombining = o.combining;
  delete o2.combining;

  // return chainer._chain( o2 );
  return _.Chainer._chain( o2 );
}

var defaults = outputTo.defaults = Object.create( null );

defaults.combining = 'append';
defaults.exclusiveOutput = 0;
defaults.originalOutput = 0;

//

/**
 * Removes output( output ) from output list if it exists.
 *
 * Removed target will not be receiving any messages from current logger.
 * @returns True if output is succesfully removed from the list, otherwise returns false.
 *
 * @param { Object } output - Logger that must be deleted from output list.
 *
 * @example
 * let l1 = new _.Logger({ output : console });
 * let l2 = new _.Logger({ output : console });
 * let l3 = new _.Logger({ output : console });
 * logger.outputTo( l1, { combining : 'rewrite' } );
 * logger.outputTo( l2, { combining : 'append' } );
 * logger.outputTo( l3, { combining : 'append' } );
 * l1._prefix = '*';
 * l2._prefix = '**';
 * l3._prefix = '***';
 *
 * logger.outputUnchain( l1 ); //returns true
 * logger.outputUnchain( l1 ); //returns false because l1 not exists in the list anymore
 * logger.log( 'msg from logger' );
 * //l2 prints '**msg from logger'
 * //l3 prints '***msg from logger'
 *
 * @method outputUnchain
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( output ) is not a Object.
 * @throws { Exception } If outputs list is empty.
 * @class wPrinterChainingMixin
 * @namespace Tools
 * @module Tools/base/Logger
 *
 */

/* qqq : should return number */

function outputUnchain( output )
{
  let self = this;
  let inputChainer = self[ chainerSymbol ];

  if( !inputChainer )
  return;

  _.assert( !!inputChainer );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  inputChainer.outputUnchain( output );
}

//

/**
 * Adds current logger( self ) to output list of logger( input ).
 *
 * Logger( self ) will take each message from source( input ).
 * If( input ) is not a Logger, write methods in( input ) will be replaced with methods from current logger( self ).
 * @returns True if logger( self ) is succesfully added to source( input ) output list, otherwise returns false.
 *
 * @param { Object } input - Object that will be input for current logger.
 * @param { Object } o  - Options.
 * @param { String } [ o.combining='rewrite' ] - Specifies combining mode for outputTo method @see {@link wTools.outputTo}.
 * By default rewrites output list of( input ) object if it exists.
 *
 * @example
 * logger.inputFrom( console );
 * logger._prefix = '*';
 * console.log( 'msg for logger' ); //logger prints '*msg for logger'
 *
 * @example
 * let l = new _.Logger({ output : console });
 * logger.inputFrom( l );
 * logger._prefix = '*';
 * l.log( 'msg from logger' ); //logger prints '*msg from logger'
 *
 * @method inputFrom
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( input ) is not a Object.
 * @class wPrinterChainingMixin
 * @namespace Tools
 * @module Tools/base/Logger
 *
 */

function inputFrom( input, o )
{
  let self = this;
  // let chainer = self[ chainerSymbol ];

  o = _.routineOptions( self.inputFrom, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  let o2 = _.mapExtend( null, o );
  o2.inputPrinter = input;
  o2.outputPrinter = self;
  // o2.inputCombining = o.combining;
  o2.outputCombining = o.combining;
  delete o2.combining;

  // return chainer._chain( o2 );
  return _.Chainer._chain( o2 );
}

var defaults = inputFrom.defaults = Object.create( null );

defaults.combining = 'append';
defaults.exclusiveOutput = 0;
defaults.originalOutput = 0;

//

/**
 * Removes current logger( self ) from output list of logger( input ).
 *
 * Logger( self ) will not be receiving any messages from source( input ).
 * If( input ) is not a Logger, restores it original write methods.
 * @returns True if logger( self ) is succesfully removed from source( input ) output list, otherwise returns false.
 *
 * @param { Object } input - Object that will not be longer an input for current logger( self ).
 *
 * @example
 * logger.inputUnchain( console );
 * logger._prefix = '*';
 * console.log( 'msg for logger' ); //console prints 'msg for logger'
 *
 * @example
 * let l = new _.Logger({ output : console });
 * logger.inputFrom( l, { combining : 'append' } );
 * logger._prefix = '*';
 * l.log( 'msg for logger' ) //logger prints '*msg for logger'
 * logger.inputUnchain( l );
 * l.log( 'msg for logger' ) //l prints 'msg for logger'
 *
 * @method inputUnchain
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( input ) is not a Object.
 * @class wPrinterChainingMixin
 * @namespace Tools
 * @module Tools/base/Logger
 *
 */

function inputUnchain( input )
{
  let self = this;
  let outputChainer = self[ chainerSymbol ];
  _.assert( arguments.length === 0 || arguments.length === 1 );
  return outputChainer.inputUnchain( input );
}

//

function unchain()
{
  let self = this;

  self.inputUnchain();
  self.outputUnchain();

}

//

function ConsoleIsBarred( output )
{
  let self = this;

  _.assert( _.consoleIs( output ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let chainer = output[ chainerSymbol ]
  if( !chainer )
  return false;

  return !!chainer.exclusiveOutputPrinter;
}

//

/*
qqq : extend test coverage, write doc. ask how
qqq : implement, test, doc method ConsoleBar
qqq : write test routine to bar, unbar, bar
qqq : write test routine to unbar, bar, unbar
*/

function ConsoleBar( o )
{
  let self = this;

  o = _.routineOptions( ConsoleBar, arguments );

  /* */

  if( o.on )
  {

    if( !o.barPrinter )
    o.barPrinter = new self.Self({ output : null, name : 'barPrinter' });
    if( !o.outputPrinter && self.instanceIs() )
    o.outputPrinter = self;
    if( !o.outputPrinter )
    o.outputPrinter = new self.Self();

    if( o.verbose )
    {
      o.outputPrinter.begin({ verbosity : 4 });
      o.outputPrinter.log( 'Barring console' );
      o.outputPrinter.end({ verbosity : 4 });
    }

    _.assert( !o.barPrinter.inputs.length );
    _.assert( !o.barPrinter.outputs.length );
    // _.assert( !o.outputPrinterHadOutputs );

    o.outputPrinterHadOutputs = o.outputPrinter.outputs.slice();
    o.outputPrinter.outputUnchain();
    o.outputPrinter.outputTo( console, { originalOutput : 1, combining : 'rewrite' } );

    o.barPrinter.permanentStyle = 'exclusiveOutput.neutral';
    o.barPrinter.inputFrom( console, { exclusiveOutput : 1 } );
    o.barPrinter.outputTo( o.outputPrinter );

    console[ barSymbol ] = o;

  }
  else
  {

    let bar = console[ barSymbol ];

    if( bar )
    {
      if( !o.outputPrinter )
      o.outputPrinter = bar.outputPrinter;
      if( !o.barPrinter )
      o.barPrinter = bar.barPrinter;
      if( !o.outputPrinterHadOutputs )
      o.outputPrinterHadOutputs = bar.outputPrinterHadOutputs;
    }

    _.assert( !!bar );
    _.assert( bar.barPrinter === o.barPrinter );
    _.assert( bar.outputPrinter === o.outputPrinter );
    _.assert( bar.outputPrinterHadOutputs === o.outputPrinterHadOutputs );

    o.barPrinter.unchain();
    o.outputPrinter.outputUnchain( console );

    _.assert( !!o.outputPrinterHadOutputs );

    for( let t = 0 ; t < o.outputPrinterHadOutputs.length ; t++ )
    {
      let outputOptions = o.outputPrinterHadOutputs[ t ];
      o.outputPrinter.outputTo( outputOptions.outputPrinter, _.mapOnly( outputOptions, o.outputPrinter.outputTo.defaults ) );
    }

    o.outputPrinterHadOutputs = null;
    delete console[ barSymbol ];

  }

  /*

      exclusiveOutput        ordinary      originalOutput
  console    ->    barPrinter  ->  outputPrinter   ->   console
    ^
    |
  others

  originalOutput link is not transitive, but terminating
  so no cycle

  console -> barPrinter -> outputPrinter -> defLogger -> console

  */

  return o;
}

ConsoleBar.defaults =
{
  outputPrinter : null,
  barPrinter : null,
  outputPrinterHadOutputs : null,
  on : 1,
  verbose : 0,
}

//

function Chain( o )
{
  _.assert( arguments.length === 1 );
  _.routineOptions( Chain, o )
  _.assert( _.printerLike( o.inputPrinter ) || _.arrayLike( o.inputPrinter ) );
  _.assert( _.printerLike( o.outputPrinter ) || _.arrayLike( o.outputPrinter ) );

  return _.Chainer._chain( o );
}

var defaults = Chain.defaults = Object.create( _.Chainer.prototype._chain.defaults );

// --
// checker
// --

function hasInput( input, o )
{
  let self = this;
  let chainer = self.chainer;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  return chainer._hasInput( input, o );
}

//

function hasInputClose( input )
{
  let self = this;
  let chainer = self.chainer;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return chainer._hasInput( input, { deep : 0 } );
}

//

function hasInputDeep( input )
{
  let self = this;
  let chainer = self.chainer;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return chainer._hasInput( input, { deep : 1 } );
}

//

function hasOutput( output, o )
{
  let self = this;
  let chainer = self.chainer;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  return chainer._hasOutput( output, o );
}

//

function hasOutputClose( output )
{
  let self = this;
  let chainer = self.chainer;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return chainer._hasOutput( output, { deep : 0 } );
}

//

function hasOutputDeep( output )
{
  let self = this;
  let chainer = self.chainer;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return chainer._hasOutput( output, { deep : 1 } );
}

// --
// etc
// --

function _outputSet( output )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( output )
  self.outputTo( output, { combining : 'rewrite' } );
  else
  self.outputUnchain();

  // self.outputTo( output, { combining : 'rewrite' } );

}

//

function _outputGet( output )
{
  let self = this;
  _.assert( _.arrayIs( self.outputs ) );
  return self.outputs.length ? self.outputs[ self.outputs.length-1 ].outputPrinter : null;
}

//

function _outputsSet( outputs )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  self.outputTo( outputs, { combining : 'rewrite' } );
}

//

function _outputsGet( outputs )
{
  let self = this;
  let chainer = self[ chainerSymbol ];
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return chainer.outputs;
}

//

function _inputsGet()
{
  let self = this;
  let chainer = self[ chainerSymbol ];
  return chainer.inputs;
}

//

function _inputsSet( inputs )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  self.inputFrom( inputs, { combining : 'rewrite' } );
}

//

function _chainerGet()
{
  let self = this;
  return _.Chainer.Get( self );
}

//

function _chainerMakeFor( printer )
{
  let self = this;
  _.assert( arguments.length === 1 );
  return _.Chainer.MakeFor( printer );
}

// --
// fields
// --

let barSymbol = Symbol.for( 'bar' );
let chainerSymbol = Symbol.for( 'chainer' );
let levelSymbol = Symbol.for( 'level' );

let ChainDescriptor = _.Chainer.ChainDescriptor;
let Combining = _.Chainer.Combining;
let Channel = _.Chainer.Channel;

let ChangeLevelMethods =
[
  'up',
  'down',
];

// --
// relations
// --

let Composes =
{

  outputs : _.define.own( [] ),
  inputs : _.define.own( [] ),

}

let Aggregates =
{
}

let Associates =
{

  output : null,

}

let Restricts =
{
  isPrinter : 1,
}

let Statics =
{

  ConsoleBar,
  ConsoleIsBarred,
  Chain,

  // fields

  ChainDescriptor,
  Combining,
  Channel,

  ChangeLevelMethods,
  unbarringConsoleOnError : 1,

}

let Forbids =
{
  format : 'format',
  upAct : 'upAct',
  downAct : 'downAct',
}

let Accessors =
{
  output : 'output',
  outputs : 'outputs',
  inputs : 'inputs',
  chainer : 'chainer',
}

// --
// declare
// --

let Functors =
{

  init,
  finit,

}

let Supplement =
{

  // // write
  //
  // _writeAct,
  // _writeToChannelWithoutExclusion,
  // _writeToChannelUp,
  // _writeToChannelDown,
  // _writeToChannelIn,
  //
  // // init
  //
  // _initChainingMixin,
  // _initChainingMixinChannel,

}

//

let Extension =
{

  // write

  _writeAct,
  _writeToChannelWithoutExclusion,
  _writeToChannelUp,
  _writeToChannelDown,
  _writeToChannelIn,

  // init

  _initChainingMixin,
  _initChainingMixinChannel,

  // chaining

  outputTo,

  outputUnchain,

  inputFrom,

  inputUnchain,

  unchain,

  ConsoleBar,
  ConsoleIsBarred,

  // checker

  hasInput,
  hasInputClose,
  hasInputDeep,

  hasOutput,
  hasOutputClose,
  hasOutputDeep,

  // etc

  _outputSet,
  _outputGet,

  _outputsSet,
  _outputsGet,

  _inputsSet,
  _inputsGet,

  _chainerGet,
  _chainerMakeFor,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  extend : Extension,
  supplement : Supplement,
  onMixinEnd,
  functors : Functors,
  withMixin : true,
  withClass : true,
});

// --
// export
// --

_[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
