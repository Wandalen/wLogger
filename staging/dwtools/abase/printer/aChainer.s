(function _aChainer_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  let _ = _global_.wTools;

  _.include( 'wProto' );

}

//

/**
 * @class wChainer
 */

var _global = _global_;
var _ = _global_.wTools;
var Parent = null;
var Self = function wChainer( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.shortName = 'Chainer';

// --
// inter
// --

function init( o )
{
  var self = this;

  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  return self;
}

//

function finit()
{
  var self = this;
  debugger;xxx

  self.unchainEverything();

  _.Copyable.finit.call( self );
}

//

function _chain( o )
{
  let self = this;
  let result = 0;

  o = _.routineOptions( self._chain, arguments );
  _.assert( arguments.length === 1 );
  _.assert( _.printerLike( o.outputPrinter ) || _._arrayLike( o.outputPrinter ) );
  _.assert( _.printerLike( o.inputPrinter ) || _._arrayLike( o.inputPrinter ) );
  _.assert( _.arrayHas( _.PrinterChainingMixin.Combining, o.outputCombining ), () => 'unknown outputCombining mode ' + _.strQuote( o.outputCombining ) );
  _.assert( _.arrayHas( _.PrinterChainingMixin.Combining, o.inputCombining ), () => 'unknown inputCombining mode ' + _.strQuote( o.inputCombining ) );

  /* */

  if( self.outputs.length )
  {
    if( o.outputCombining === 'supplement' )
    {
      debugger; xxx
      result = 0;
      return result;
    }
    else if( o.outputCombining === 'rewrite' )
    {
      debugger;
      self.outputUnchain();
    }
  }

  /* */

  if( self.inputs.length )
  {
    if( o.inputCombining === 'supplement' )
    {
      debugger; xxx
      result = 0;
      return result;
    }
    else if( o.inputCombining === 'rewrite' )
    {
      self.inputUnchain();
    }
  }

  /* */

  if( _._arrayLike( o.outputPrinter ) )
  {

    o.outputPrinter.forEach( ( outputPrinter ) =>
    {
      debugger; xxx
      var o2 = _.mapExtend( null, o );
      o2.outputPrinter = outputPrinter;
      result += self._chain( o2 );
    });

    return result;
  }

  /* */

  if( _._arrayLike( o.inputPrinter ) )
  {

    o.inputPrinter.forEach( ( inputPrinter ) =>
    {
      debugger; xxx
      var o2 = _.mapExtend( null, o );
      o2.inputPrinter = inputPrinter;
      result += self._chain( o2 );
    });

    return result;
  }

  /* */

  _.assert( o.outputPrinter, 'expects {-o.outputPrinter-}' );
  _.assert( self !== o.outputPrinter, 'Output to itself is not correct chaining' );

  if( Config.debug )
  if( self.hasOutputClose( o.outputPrinter ) )
  _.assert( 0, () => _.strConcat([ 'Close loop', _.toStrShort( o.inputPrinter ), 'outputPrinter to', _.toStrShort( o.outputPrinter ) ]) );

  /* input check */

  if( Config.debug )
  if( self.hasInputClose( o.inputPrinter ) )
  _.assert( 0, () => _.strConcat([ 'Close loop', _.toStrShort( o.inputPrinter ), 'outputPrinter to', _.toStrShort( o.outputPrinter ) ]) );

  /*
    no need to check inputs if chaining is originalOutput
  */

  if( Config.debug )
  if( !o.originalOutput )
  if( self.hasInputDeep( o.outputPrinter ) )
  _.assert( 0, () => _.strConcat([ 'Deep loop', _.toStrShort( o.inputPrinter ), 'outputPrinter to', _.toStrShort( o.outputPrinter ) ]) );

  let cd = self._chainDescriptorMake( o );

  // if( !cd.combining )
  // _.assert( self.outputs.length === 0, 'if combining is off then multiple outputs are not allowed' );

  let inputChainer = cd.inputPrinter[ chainerSymbol ] || self._chainerMakeFor( cd.inputPrinter );
  let outputChainer = cd.outputPrinter[ chainerSymbol ] || self._chainerMakeFor( cd.outputPrinter );

  if( cd.outputCombining === 'prepend' )
  {
    _.arrayPrependOnceStrictly( outputChainer.inputs, cd );
  }
  else
  {
    _.arrayAppendOnceStrictly( outputChainer.inputs, cd );
  }

  if( cd.inputCombining === 'prepend' )
  {
    _.arrayPrependOnceStrictly( inputChainer.outputs, cd );
  }
  else
  {
    _.arrayAppendOnceStrictly( inputChainer.outputs, cd );
  }

  /**/

  if( _.streamIs( cd.outputPrinter ) )
  {
    debugger; xxx
    self._outputToStream( cd );
  }
  else if( _.consoleIs( cd.outputPrinter ) )
  {
    result = self._outputToConsole( cd );
  }

  if( _.streamIs( cd.inputPrinter ) )
  {
    debugger; xxx
    result = self._inputFromStream( cd );
  }
  else if( _.consoleIs( cd.inputPrinter ) )
  {
    result = self._inputFromConsole( cd );
  }

  /* */

  if( cd.originalOutput )
  {
    outputChainer.hasOriginalOutputs = +1;
  }

  if( cd.exclusiveOutput )
  {
    _.assert( !inputChainer.exclusiveOutputPrinter, 'console is already excluded by printer', _.toStrShort( inputChainer.exclusiveOutputPrinter ) );
    inputChainer.exclusiveOutputPrinter = o.outputPrinter;
  }

  return result;
}

_chain.defaults =
{
  outputPrinter : null,
  inputPrinter : null,
  outputCombining : 'append', /*xxx*/
  inputCombining : 'append', /*xxx*/
  originalOutput : 0,
  exclusiveOutput : 0,
}

//

function _inputFromConsole( cd )
{
  let self = this;
  let inputChainer = cd.inputPrinter[ chainerSymbol ];

  _.assert( arguments.length === 1 );
  _.assert( _.consoleIs( cd.inputPrinter ) );
  _.assert( cd.inputPrinter.outputs === undefined );
  _.assert( !cd.inputPrinter.isPrinter );
  _.assert( inputChainer );

}

//

function _outputToConsole( cd )
{
  let self = this;
  let outputChainer = cd.outputPrinter[ chainerSymbol ];

  _.assert( arguments.length === 1 );
  _.assert( _.consoleIs( cd.outputPrinter ) );
  _.assert( cd.outputPrinter.outputs === undefined );
  _.assert( !cd.outputPrinter.isPrinter );
  _.assert( outputChainer );

  self.Channel.forEach( ( channel, c ) =>
  {
    cd.outputPrinter[ channel ] = outputChainer.writeFromConsole[ channel ];
  });

}

//

function _outputToStream( cd )
{
  let self = this;
  let stream = cd.outputPrinter;

  _.assert( stream.writable && _.routineIs( stream._write ) && _.objectIs( stream._writableState ), 'Provided stream is not writable!.' );

  self.Channel.forEach( ( channel, c ) =>
  {
    cd.write[ channel ] = function()
    {
      stream.write.apply( stream, arguments );
    }
  })();

}

//

function _inputFromStream( cd )
{
  let self = this;

  let outputChannel = 'log';

  _.assert( stream.readable && _.routineIs( stream._read ) && _.objectIs( stream._readableState ), 'Provided stream is not readable!.' );

  if( !stream.onDataHandler )
  {
    stream.on( 'data', function( data )
    {
      if( _.bufferAnyIs( data ) )
      data = _.bufferToStr( data );

      if( _.strEnds( data,'\n' ) )
      data = _.strRemoveEnd( data,'\n' );

      for( let d = 0 ; d < stream.outputs.length ; d++ )
      stream.outputs[ d ].outputPrinter[ outputChannel ].call( stream.outputs[ d ].outputPrinter, data );
    })
    stream.onDataHandler = 1;
  }
}

//

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
 * @memberof wPrinterMid
 *
 */

function outputTo( output, o )
{
  let self = this;

  debugger; xxx

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routineOptions( self.outputTo, o );

  var o2 = _.mapExtend( null, o );
  o2.inputPrinter = self.printer;
  o2.outputPrinter = output;
  o2.outputCombining = o.combining;
  delete o2.combining;

  return self._chain( o2 );

  // _.assert( arguments.length === 1 );
  // _.assert( _.printerLike( output ) || output === null || _._arrayLike( output ) );
  // _.assert( !o.combining || _.arrayHas( self.Combining, o.combining ), () => 'unknown combining mode ' + _.strQuote( o.combining ) );

  // /* output */
  //
  // if( _._arrayLike( output ) )
  // {
  //
  //   if( o.combining === 'rewrite' )
  //   {
  //     self.outputUnchain();
  //     o = _.mapExtend( null, o );
  //     o.combining = 'append';
  //   }
  //   output.forEach( ( output ) =>
  //   {
  //     self.outputTo( output );
  //   });
  //
  // }
  // else if( output === null )
  // {
  //
  //   if( self.outputs.length )
  //   {
  //     if( o.combining === 'rewrite' )
  //     return self.outputUnchain();
  //     else _.assert( 0,'outputTo can remove outputs only if {-o.combining-} is "rewrite"' );
  //   }
  //
  // }
  // else
  // {
  //
  //   _.assert( output, 'expects {-output-}' );
  //   _.assert( self !== output, 'Output to itself is not correct chaining' );
  //
  //   if( Config.debug )
  //   if( o.combining !== 'rewrite' )
  //   if( self.hasOutputClose( output ) )
  //   _.assert( 0, () => _.strConcat([ 'Close loop', _.toStrShort( self ), 'output to', _.toStrShort( output ) ]) );
  //
  //   /*
  //     no need to check inputs if chaining is originalOutput
  //   */
  //
  //   if( Config.debug )
  //   if( !o.originalOutput )
  //   if( self.inputs )
  //   if( self.hasInputDeep( output ) )
  //   _.assert( 0, () => _.strConcat([ 'Deep loop', _.toStrShort( self ), 'output to', _.toStrShort( output ) ]) );
  //
  //   // debugger;
  //   // if( !output.inputs )
  //   // output.inputs = [];
  //
  //   if( self.outputs.length )
  //   {
  //     if( o.combining === 'supplement' )
  //     return false;
  //     else if( o.combining === 'rewrite' )
  //     self.outputs.splice( 0,self.outputs.length );
  //   }
  //
  //   o.outputPrinter = output;
  //   o.inputPrinter = self;
  //
  //   let cd = self._chainDescriptorMake( o );
  //
  //   if( !cd.combining )
  //   _.assert( self.outputs.length === 0, 'if combining is off then multiple outputs are not allowed' );
  //
  //   let inputChainer = self[ chainerSymbol ] || self._chainerMakeFor( self );
  //   let outputChainer = output[ chainerSymbol ] || self._chainerMakeFor( output );
  //
  //   if( cd.combining === 'prepend' )
  //   {
  //     _.arrayPrependOnceStrictly( inputChainer.outputs, cd );
  //     _.arrayPrependOnceStrictly( outputChainer.inputs, cd );
  //   }
  //   else
  //   {
  //     _.arrayAppendOnceStrictly( inputChainer.outputs, cd );
  //     _.arrayAppendOnceStrictly( outputChainer.inputs, cd );
  //   }
  //
  //   // if( output._inputFromAfter )
  //   // {
  //   //   output._inputFromAfter( cd );
  //   // }
  //   // else
  //   // {
  //   //   return self._inputFromConsole( cd );
  //   // }
  //
  //   if( _.streamIs( output ) )
  //   {
  //     debugger; xxx
  //     return self._outputToStream( cd );
  //   }
  //
  //   // else if( cd.originalOutput )
  //   // {
  //   //   return _outputUnbarring( cd );
  //   // }
  //
  // }
  //
  // return 1;
}

outputTo.defaults =
{
  combining : 'append',
  originalOutput : 0,
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
 * @memberof wPrinterMid
 *
 */

function inputFrom( input, o )
{
  let self = this;

  debugger; xxx

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o = _.routineOptions( self.outputTo, o );

  var o2 = _.mapExtend( null, o );
  o2.inputPrinter = input;
  o2.outputPrinter = self.printer;
  o2.inputCombining = o.combining;
  delete o2.combining;

  return self._chain( o2 );
}

let defaults = inputFrom.defaults = Object.create( null );

defaults.combining = 'append';
defaults.exclusiveOutput = 0;

//

function inputsUnchainAll()
{
  let self = this;
  let result = 0;

  _.assert( arguments.length === 0 );

  self.inputs.forEach( ( input ) =>
  {
    result += self.inputUnchain( input.inputPrinter );
  });

  return result;
}

//

function outputsUnchainAll()
{
  let self = this;
  let result = 0;

  _.assert( arguments.length === 0 );

  self.inputs.forEach( ( input ) =>
  {
    result += self.outputUnchain( input.inputPrinter );
  });

  return result;
}

//

function _unchain( o )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.printerLike( o.outputPrinter ) );
  _.assert( _.printerLike( o.inputPrinter ) );
  _.assert( o.inputPrinter !== o.outputPrinter );

  let inputChainer = o.inputPrinter[ chainerSymbol ];
  let outputChainer = o.outputPrinter[ chainerSymbol ];
  let cd1 = _.arrayRemovedOnceElementStrictly( inputChainer.outputs, o.outputPrinter, ( cd ) => cd.outputPrinter, ( e ) => e );
  let cd2 = _.arrayRemovedOnceElementStrictly( outputChainer.inputs, o.inputPrinter, ( cd ) => cd.inputPrinter, ( e ) => e );

  _.assert( cd1 === cd2 );

  self._chainDescriptorFree( cd1 );

  if( cd1.exclusiveOutput )
  {
    _.assert( inputChainer.exclusiveOutputPrinter === o.outputPrinter )
    inputChainer.exclusiveOutputPrinter = null;
  }

  if( cd1.originalOutput )
  {
    outputChainer.hasOriginalOutputs -= 1;
    _.assert( outputChainer.hasOriginalOutputs >= 0 );
  }

  return 1;
}

_unchain.defaults =
{
  inputPrinter : null,
  outputPrinter : null,
}

//

function outputUnchain( output )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.printerLike( output ) || output === undefined );
  // _.assert( self !== output, 'Can not remove outputPrinter from outputs' );

  if( output === undefined )
  {
    let result = 0;
    self.outputs.forEach( ( output ) =>
    {
      result += self.outputUnchain( output.outputPrinter );
    });
    return result;
  }

  return self._unchain({ inputPrinter : self.printer, outputPrinter : output });
}

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
 * @memberof wPrinterMid
 *
 */

function inputUnchain( input )
{
  let self = this;
  let result = 0;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.printerLike( input ) || input === undefined );

  if( input === undefined )
  {
    let result = 0;
    self.inputs.forEach( ( input ) =>
    {
      result += self.inputUnchain( input.inputPrinter );
    });
    return result;
  }

  return self._unchain({ inputPrinter : input, outputPrinter : self.printer });

  // // debugger;
  // // let chainer = input[ chainerSymbol ];
  // // let cds = chainer.outputs;
  // // let cd1 = _.arrayRemovedOnceElementStrictly( self.inputs, input, ( cd ) => cd.inputPrinter, ( e ) => e );
  // // let cd2 = _.arrayRemovedOnceElementStrictly( cds, self, ( cd ) => cd.outputPrinter, ( e ) => e );
  // // _.assert( cd1 === cd2 )
  // // self._chainDescriptorFree( cd1 );
  // //
  // // if( cd1.exclusiveOutput )
  // // {
  // //   _.assert( chainer.exclusiveOutputPrinter === self )
  // //   chainer.exclusiveOutputPrinter = null;
  // // }
  // //
  // // /* xxx : only one instance */
  //
  // // for( let i = self.inputs.length-1 ; i >= 0  ; i-- )
  // // if( self.inputs[ i ].inputPrinter === input || input === undefined )
  // // {
  // //   let ainput = self.inputs[ i ].inputPrinter;
  // //
  // //   if( _.routineIs( ainput.outputUnchain ) )
  // //   {
  // //     result += ainput.outputUnchain( self ); xxx
  // //     continue;
  // //   }
  // //
  // //   result += self._inputUnchainConsoleLike( ainput );
  // //   self.inputs.splice( i, 1 );
  // // }
  //
  // return result;
}

inputUnchain.defaults =
{
  inputPrinter : null,
  outputPrinter : null,
}

//

function unchainEverything()
{
  let self = this;
  let result = 0;

  _.assert( arguments.length === 0 );

  result += self.outputUnchain();
  result += self.inputUnchain();

  return result;
}

// --
//
// --

function _chainDescriptorMake( o )
{
  var self = this;
  _.assert( arguments.length === 1 );
  let r = Object.create( null );

  Object.assign( r, self.ChainDescriptor );

  /* !!! : remove it later */
  _.accessorForbid
  ({
    object : o,
    names :
    {
      input : 'input',
      output : 'output',
    }
  });

  Object.preventExtensions( r );
  Object.assign( r, o );
  return r;
}

//

function _chainDescriptorFree( cd )
{
  _.assert( arguments.length === 1 );
  cd.freed = 1;
  Object.freeze( cd );
}

//

function _chainerMakeFor( printer )
{
  let self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.printerLike( printer ) );
  _.assert( !printer[ chainerSymbol ] );

  let chainer = new Self();
  chainer.printer = printer;
  printer[ chainerSymbol ] = chainer;

  self.Channel.forEach( ( channel, c ) =>
  {
    _.assert( _.routineIs( printer[ channel ] ), () => 'console should have method ' + _.strQuote( channel ) );

    if( _.consoleIs( printer ) )
    {
      chainer.originalWrite[ channel ] = printer[ channel ];
    }
    else chainer.originalWrite[ channel ] = function writeToChannelWithoutExclusion()
    {
      debugger;
      return this._writeToChannelWithoutExclusion( channel, arguments );
    }

    if( _.consoleIs( printer ) )
    chainer.writeFromConsole[ channel ] = _.routineJoin( undefined, self._chainerWriteToConsole, [ channel ] );
    else
    chainer.writeFromConsole[ channel ] = _.routineJoin( undefined, self._chainerWriteToPrinter, [ channel ] );

  });

  return chainer;
}

//

function _chainerWriteToConsole( channel )
{
  let result;
  let console = this;
  let chainer = this[ chainerSymbol ];
  let cds = chainer.outputs;
  let args = _.longSlice( arguments, 1 );

  _.assert( _.arrayIs( cds ) );
  _.assert( chainer.originalWrite[ channel ] );

  if( chainer.exclusiveOutputPrinter )
  {
    result = chainer.exclusiveOutputPrinter[ channel ].apply( chainer.exclusiveOutputPrinter, args );
  }

  if( !chainer.exclusiveOutputPrinter /*|| chainer.hasOriginalOutputs*/ )
  cds.forEach( ( cd ) =>
  {
    _.assert( cd.inputPrinter === console );
    if( !chainer.exclusiveOutputPrinter || cd.originalOutput )
    cd.outputPrinter[ channel ].apply( cd.outputPrinter, args );
  });

  if( chainer.exclusiveOutputPrinter )
  return result;
  else
  return chainer.originalWrite[ channel ].apply( console, args );
}

//

function _chainerWriteToPrinter( channel )
{
  let result;
  let self = this;
  let chainer = this[ chainerSymbol ];
  let cds = chainer.outputs;
  let args = _.longSlice( arguments, 1 );

  debugger; xxx

  _.assert( _.arrayIs( cds ) );
  _.assert( chainer.originalWrite[ channel ] );

  if( chainer.exclusiveOutputPrinter )
  {
    result = chainer.exclusiveOutputPrinter[ channel ].apply( chainer.exclusiveOutputPrinter, arguments );
  }

  if( chainer.exclusiveOutputPrinter )
  return result;
  else
  return chainer.originalWrite[ channel ].apply( self, arguments );

}

// --
//
// --

function _nameGet()
{
  var self = this;
  return self.printer.name;
}

//

function _nameSet( src )
{
  var self = this;

  if( src === null )
  return;

  self.printer.name = src
}

// --
// checker
// --

function _hasInput( input,o )
{
  let self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.mapIs( o ) );
  _.assert( _.printerLike( input ) || _.processIs( input ) );
  _.routineOptions( _hasInput, o );

  for( let d = 0 ; d < self.inputs.length ; d++ )
  {
    if( self.inputs[ d ].inputPrinter === input )
    {
      if( o.withoutOutputToOriginal && self.inputs[ d ].originalOutput )
      continue;
      return true;
    }
  }

  if( o.deep )
  for( let d = 0 ; d < self.inputs.length ; d++ )
  {
    let inputs = self.inputs[ d ].inputPrinter.inputs;
    if( o.withoutOutputToOriginal && self.inputs[ d ].originalOutput )
    continue;
    if( inputs && inputs.length )
    {
      if( _hasInput.call( self.inputs[ d ].inputPrinter, input, o ) )
      return true;
    }
  }

  return false;
}

_hasInput.defaults =
{
  deep : 1,
  withoutOutputToOriginal : 1,
}

//

function hasInputClose( input )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  return self._hasInput( input,{ deep : 0 } );
}

//

function hasInputDeep( input )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  return self._hasInput( input,{ deep : 1 } );
}

//

function _hasOutput( output,o )
{
  let self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.mapIs( o ) );
  _.assert( _.printerLike( output ) || _.processIs( output ));
  _.routineOptions( _hasOutput,o );

  for( let d = 0 ; d < self.outputs.length ; d++ )
  {
    if( self.outputs[ d ].outputPrinter === output )
    {
      if( o.withoutOutputToOriginal && self.outputs[ d ].originalOutput )
      continue;
      // debugger;
      return true;
    }
  }

  if( o.deep )
  for( let d = 0 ; d < self.outputs.length ; d++ )
  {
    let outputs = self.outputs[ d ].outputPrinter.outputs;
    if( o.withoutOutputToOriginal && self.outputs[ d ].originalOutput )
    continue;
    if( outputs && outputs.length )
    {
      if( _hasOutput.call( self.outputs[ d ].outputPrinter, output, o ) )
      return true;
    }
  }

  return false;
}

_hasOutput.defaults =
{
  deep : 1,
  withoutOutputToOriginal : 1,
}

//

function hasOutputClose( output )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  return self._hasOutput( output,{ deep : 0 } );
}

//

function hasOutputDeep( output )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  return self._hasOutput( output,{ deep : 1 } );
}

// --
// fields
// --

let chainerSymbol = Symbol.for( 'chainer' );

let ChainDescriptor =
{
  exclusiveOutput : 0,
  originalOutput : 0,
  inputPrinter : null,
  outputPrinter : null,
  // write : null,
  freed : 0,

  inputCombining : null,
  outputCombining : null,

}

let Combining = [ 'rewrite', 'supplement', 'append', 'prepend' ];

let Channel =
[
  'log',
  'error',
  'info',
  'warn',
  'debug'
];

// let ChainDescriptor =
// {
//
//   exclusiveOutput : 0,
//   originalOutput : 0,
//   combining : null,
//   inputPrinter : null,
//   outputPrinter : null,
//   write : null,
//   freed : 0,
//
// }

// --
// relationships
// --

let Composes =
{
  name : null,
  hasOriginalOutputs : 0,
}

let Aggregates =
{
}

let Associates =
{
  printer : null,
  inputs : _.define.multiple([]),
  outputs : _.define.multiple([]),
  originalWrite : _.define.multiple({}),
  writeFromConsole : _.define.multiple({}),
  exclusiveOutputPrinter : null,
}

let Restricts =
{
}

let Statics =
{

  _chainerMakeFor : _chainerMakeFor,
  _chainerWriteToConsole : _chainerWriteToConsole,
  _chainerWriteToPrinter : _chainerWriteToPrinter,

  ChainDescriptor : ChainDescriptor,
  Combining : Combining,
  Channel : Channel,

}

let Forbids =
{
  chainDescriptors : 'chainDescriptors',
}

let Accessors =
{
  name : 'name',
}

// --
// define class
// --

let Extend =
{

  // inter

  init : init,
  finit : finit,

  _chain : _chain,

  _outputToConsole : _outputToConsole,
  _inputFromConsole : _inputFromConsole,
  _outputToStream : _outputToStream,
  _inputFromStream : _inputFromStream,

  outputTo : outputTo,
  inputFrom : inputFrom,

  _unchain : _unchain,
  outputUnchain : outputUnchain,
  inputUnchain : inputUnchain,
  unchainEverything : unchainEverything,

  //

  _chainDescriptorMake : _chainDescriptorMake,
  _chainDescriptorFree : _chainDescriptorFree,
  _chainerMakeFor : _chainerMakeFor,
  _chainerWriteToConsole : _chainerWriteToConsole,
  _chainerWriteToPrinter : _chainerWriteToPrinter,

  //

  _nameGet : _nameGet,
  _nameSet : _nameSet,

  // checker

  _hasInput : _hasInput,
  hasInputClose : hasInputClose,
  hasInputDeep : hasInputDeep,

  _hasOutput : _hasOutput,
  hasOutputClose : hasOutputClose,
  hasOutputDeep : hasOutputDeep,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,
  Accessors : Accessors,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

_.Copyable.mixin( Self );

// --
// export
// --

_[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
