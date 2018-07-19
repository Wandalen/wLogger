(function _aChainingMixin_s_() {

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

  var _ = _global_.wTools;

  _.include( 'wProto' );

}

var _global = _global_;
var _ = _global_.wTools;

//

function _mixin( cls )
{

  var dstProto = cls.prototype;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.routineIs( cls ) );

  _.mixinApply
  ({
    dstProto : dstProto,
    descriptor : Self,
  });

  /* */

  _.accessor
  ({
    object : dstProto,
    names :
    {
      output : 'output',
    }
  });

  /* */

  _.accessorForbid
  ({
    object : dstProto,
    names :
    {
      format : 'format',
      upAct : 'upAct',
      downAct : 'downAct',
    }
  });

  /* */

  dstProto._initChainingMixin();

}

//

function _initChainingMixin()
{
  var proto = this;
  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) );

  for( var m = 0 ; m < proto.Channels.length ; m++ )
  proto.__initChainingMixinChannel( Channels[ m ] );

}

//

function __initChainingMixinChannel( name )
{
  var proto = this;

  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) )
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( name ) );

  if( proto[ name ] )
  return;

  /* */

  function write()
  {
    this._writeToChannel( name,_.longSlice( arguments ) );
    return this;
  }

  /* */

  function writeUp()
  {

    this._writeToChannelUp( name,arguments );

    return this;
  }

  /* */

  function writeDown()
  {

    this._writeToChannelDown( name,arguments );

    return this;
  }

  /* */

  function writeIn()
  {

    this._writeToChannelIn( name,arguments );

    return this;
  }

  /* */

  proto[ name ] = write;
  proto[ name + 'Up' ] = writeUp;
  proto[ name + 'Down' ] = writeDown;
  proto[ name + 'In' ] = writeIn;

}

//

function _writeToChannel( channelName,args )
{
  var self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( channelName ) );
  _.assert( _.longIs( args ) );

  var o = self.write.apply( self,args );

  if( !o )
  return;

  for( var i = 0 ; i < self.outputs.length ; i++ )
  {
    var outputDescriptor = self.outputs[ i ];
    var outputData = ( outputDescriptor.output.isTerminal === undefined || outputDescriptor.output.isTerminal ) ? o.outputForTerminal : o.output;

    _.assert( _.longIs( outputData ) );

    // /* skip empty line output if logging directive without text, like: logger.log( '#foreground : red#' )
    //  output is not skipped for logger.log()
    // */
    //xxx
    // if( !outputData.length )
    // continue;

    if( outputDescriptor.methods[ channelName ] )
    outputDescriptor.methods[ channelName ].apply( outputDescriptor.output,outputData );
    else
    {
      _.assert( _.routineIs( outputDescriptor.output[ channelName ] ) );
      outputDescriptor.output[ channelName ].apply( outputDescriptor.output,outputData );
    }
  }

}

//

function _writeToChannelUp( channelName,args )
{
  var self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( channelName ) );
  _.assert( _.longIs( args ) );

  self.up();

  self.begin( 'head' );
  self._writeToChannel( channelName,args );
  self.end( 'head' );

}

//

function _writeToChannelDown( channelName,args )
{
  var self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( channelName ) );
  _.assert( _.longIs( args ) );

  self.begin( 'tail' );
  self._writeToChannel( channelName,args );
  self.end( 'tail' );

  self.down();

}

//

function _writeToChannelIn( channelName,args )
{
  var self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( channelName ) );
  _.assert( _.longIs( args ) );
  _.assert( args.length === 2 );
  _.assert( _.strIs( args[ 0 ] ) );

  var tag = Object.create( null );
  tag[ args[ 0 ] ] = args[ 1 ];

  self.begin( tag );
  self._writeToChannel( channelName,[ args[ 1 ] ] );
  self.end( tag );

}

// --
// write
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
 * var l = new _.Logger({ output : console });
 * l.outputTo( logger, { combining : 'rewrite' } ); //returns true
 * logger._prefix = '--';
 * l.log( 'abc' );//logger prints '--abc'
 *
 * @example
 * var l1 = new _.Logger({ output : console });
 * var l2 = new _.Logger({ output : console });
 * l1.outputTo( logger, { combining : 'rewrite' } );
 * l2.outputTo( l1, { combining : 'rewrite' } );
 * logger._prefix = '*';
 * logger._postfix = '*';
 * l2.log( 'msg from l2' );//logger prints '*msg from l2*'
 *
 * @example
 * var l1 = new _.Logger({ output : console });
 * var l2 = new _.Logger({ output : console });
 * var l3 = new _.Logger({ output : console });
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
 * var l1 = new _.Logger({ output : console });
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

function outputTo( output,o )
{
  var self = this;
  var knownCombining = [ 'rewrite','supplement','append','prepend' ];

  var o = _.routineOptions( self.outputTo, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( output ) || _.consoleIs( output ) || output === null );
  _.assert( !o.combining || _.arrayHas( knownCombining, o.combining ), 'unknown combining mode',o.combining );

  /* output */

  if( output )
  {

    _.assert( self !== output, 'outputTo : Adding of itself to outputs is not allowed' );

    if( o.combining !== 'rewrite' )
    if( self.hasOutputNotDeep( output ) )
    throw _.err( 'outputTo : This output already exists as immediate output', output );

    /*
      no need to check inputs if chaining is unbarring
    */

    if( !o.unbarring )
    if( self.inputs )
    if( self.hasInputDeep( output ) )
    throw _.err( 'outputTo : This object already exists in input chain', output );

    if( !output.inputs )
    output.inputs = [];

    if( self.outputs.length )
    {
      if( o.combining === 'supplement' )
      return false;
      else if( o.combining === 'rewrite' )
      self.outputs.splice( 0,self.outputs.length );
    }

    o.output = output;
    o.input = self;
    o.methods = Object.create( null );
    Object.preventExtensions( o );

    if( !o.combining )
    _.assert( self.outputs.length === 0, 'if combining is off then multiple outputs are not allowed' );

    if( o.combining === 'prepend' )
    {
      self.outputs.unshift( o );
      output.inputs.unshift( o );
    }
    else
    {
      self.outputs.push( o );
      output.inputs.push( o );
    }

    if( _.streamIs( output ) ) // ???
    {
      self._outputToStream( o );
      return true;
    }

    // if( o.unbarring )
    // debugger;
    if( o.unbarring )
    _.assert( output.isTerminal === undefined || output.isTerminal, 'unbarring chaining possible only into terminal logger' );

    if( o.unbarring )
    for( var m = 0 ; m < self.Channels.length ; m++ ) (function()
    {
      var name = self.Channels[ m ];
      o.methods[ name ] = function()
      {

        /*
          unbarred output data into terminal logger with help of original methods
          without passing message forward in a chain
        */

        if( this[ symbolForChainDescriptor ] && this[ symbolForChainDescriptor ].originalMethods[ name ] )
        return this[ symbolForChainDescriptor ].originalMethods[ name ].apply( this,arguments );
        else
        return this[ name ].apply( this,arguments );

      }
    })();

  }
  else
  {
    if( self.outputs.length )
    {
      if( o.combining === 'rewrite' )
      {
        for( var d = 0; d < self.outputs.length ; d++ )
        self.outputUnchain( self.outputs[ d ].output );
        self.outputs.splice( 0,self.outputs.length );
      }
      else _.assert( 0,'outputTo can remove outputs only if ( o.combining ) is "rewrite"' );
    }
  }

  return true;
}

outputTo.defaults =
{
  combining : 0,
  unbarring : 0,
}

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
 * var l1 = new _.Logger({ output : console });
 * var l2 = new _.Logger({ output : console });
 * var l3 = new _.Logger({ output : console });
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
 * @memberof wPrinterMid
 *
 */

function outputUnchain( output )
{
  var self = this;

  if( !self.outputs.length )
  return false;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.objectIs( output ) || _.consoleIs( output ) || output === undefined );
  _.assert( self.outputs.length, 'outputUnchain : outputs list is empty' );
  _.assert( self !== output, 'outputUnchain : Can not remove itself from outputs' );

  if( output === undefined )
  {
    var result = false;
    for( var i = 0 ; i < self.outputs.length ; i++ )
    result = self.outputUnchain( self.outputs[ i ].output ) || result;
    return result;
  }

  var result = _.arrayRemovedOnce( self.outputs, output, ( e ) => e.output, ( e ) => e ) >= 0;

  if( output.inputs )
  _.arrayRemovedOnce( output.inputs, self, ( e ) => e.input, ( e ) => e );

  return result;
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
 * var l = new _.Logger({ output : console });
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

function inputFrom( input,o )
{
  var self = this;
  var o = o || Object.create( null );
  var knownCombining = [ 'rewrite','append','prepend' ];

  _.routineOptions( self.inputFrom,o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( input ) || _.consoleIs( input ) || _.processIs( input ) || input === null );

  if( _.routineIs( input.outputTo ) )
  return input.outputTo( self,_.mapOnly( o, input.outputTo.defaults ) );

  _.assert( !o.combining || knownCombining.indexOf( o.combining ) !== -1, 'unknown combining mode',o.combining );

  /* input is barred check */

  if( Config.debug )
  {
    if( o.barring && _.consoleIs( input ) && self.consoleIsBarred( input )  )
    {
      if( self.unbarringConsoleOnError )
      {
        var chainDescriptor = input[ symbolForChainDescriptor ];
        _.assert( chainDescriptor && chainDescriptor.bar );
        chainDescriptor.bar.unchain();
      }
      throw _.err( 'inputFrom : This input is already barred', input );
    }
  }

  /* input check */

  if( o.combining !== 'rewrite' )
  if( self.hasInputNotDeep( input ) )
  throw _.err( 'inputFrom : This input already exists as input in the chain', input );

  /* recursive outputs check */

  if( self.hasOutputDeep( input ) )
  throw _.err( 'inputFrom : This input already exists as output in the chain', input );

  /* */

  if( !input.outputs )
  {
    input.outputs = [];
  }

  if( input.outputs.length )
  {
    if( o.combining === 'rewrite' )
    input.outputs.splice( 0,input.outputs.length );
  }

  /* */

  o.output = self;
  o.input = input;

  if( o.combining === 'prepend' )
  input.outputs.unshift( o );
  else
  input.outputs.push( o );

  self.inputs.push( o );

  var chainDescriptor = input[ symbolForChainDescriptor ];
  if( !chainDescriptor )
  {
    chainDescriptor = input[ symbolForChainDescriptor ] = Object.create( null );
    chainDescriptor.bar = null;
    // chainDescriptor.barringMethods = Object.create( null );
    chainDescriptor.originalMethods = Object.create( null );
  }

  o.chainDescriptor = chainDescriptor;

  /* */

  if( _.streamIs( input ) )
  {
    self._inputFromStream( input );
  }
  else
  {
    for( var m = 0 ; m < self.Channels.length ; m++ ) ( function()
    {
      var channel = self.Channels[ m ];

      _.assert( input[ channel ],'inputFrom expects input has method',channel );

      if( !chainDescriptor.originalMethods[ channel ] )
      {
        _.assert( !chainDescriptor.bar );
        chainDescriptor.originalMethods[ channel ] = input[ channel ];
        // chainDescriptor.barringMethods[ channel ] = input[ channel ];
        input[ channel ] = function()
        {
          if( chainDescriptor.bar )
          return chainDescriptor.bar[ channel ].apply( chainDescriptor.bar,arguments );
          for( var d = 0 ; d < input.outputs.length ; d++ )
          input.outputs[ d ].output[ channel ].apply( input.outputs[ d ].output, arguments );
          return chainDescriptor.originalMethods[ channel ].apply( input, arguments );
        }
      }

    })();
  }

  /* */

  if( o.barring )
  chainDescriptor.bar = self;

  return true;
}

inputFrom.defaults =
{
  combining : 'append',
  barring : 0,
}

inputFrom.defaults.__proto__ = outputTo.defaults;

//

function _inputFromStream( stream )
{
  var self = this;

  var outputChannel = 'log';

  _.assert( stream.readable && _.routineIs( stream._read ) && _.objectIs( stream._readableState ), 'Provided stream is not readable!.' );

  if( !stream.onDataHandler )
  {
    stream.on( 'data', function( data )
    {
      if( _.bufferAnyIs( data ) )
      data = _.bufferToStr( data );

      if( _.strEnds( data,'\n' ) )
      data = _.strRemoveEnd( data,'\n' );

      for( var d = 0 ; d < stream.outputs.length ; d++ )
      stream.outputs[ d ].output[ outputChannel ].call( stream.outputs[ d ].output, data );
    })
    stream.onDataHandler = 1;
  }
}

//

function _outputToStream( o )
{
  var self = this;

  var stream = o.output;

  _.assert( stream.writable && _.routineIs( stream._write ) && _.objectIs( stream._writableState ), 'Provided stream is not writable!.' );

  for( var m = 0 ; m < self.Channels.length ; m++ ) (function()
  {
    var name = self.Channels[ m ];
    o.methods[ name ] = function()
    {
      stream.write.apply( stream, arguments );
    }
  })();

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
 * var l = new _.Logger({ output : console });
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
  var self = this;
  var result = false;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.objectIs( input ) || _.consoleIs( input ) || input === undefined );

  for( var i = self.inputs.length-1 ; i >= 0  ; i-- )
  if( self.inputs[ i ].input === input || input === undefined )
  {
    var ainput = self.inputs[ i ].input;

    if( _.routineIs( ainput.outputUnchain ) )
    {
      result = ainput.outputUnchain( self );
      continue;
    }

    result = self._inputUnchainForeign( ainput ) || result;
    self.inputs.splice( i, 1 );
  }

  return result;
}

//

function _inputUnchainForeign( input )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( ( _.objectIs( input ) || _.consoleIs( input ) ) && !( input instanceof _.PrinterBase ) );

  /* */

  var result = _.arrayRemovedOnce( input.outputs, self, ( e ) => e.output, ( e ) => e ) >= 0;

  if( !input.outputs.length )
  {
    var chainDescriptor = input[ symbolForChainDescriptor ];
    for( var m = 0 ; m < self.Channels.length ; m++ )
    {
      var name = self.Channels[ m ];
      _.assert( input[ name ],'inputUnchain expects input has method',name,'something wrong' );
      input[ name ] = chainDescriptor.originalMethods[ name ];
    }

    delete input.outputs;
    delete input[ symbolForChainDescriptor ];
  }
  else
  {
    var chainDescriptor = input[ symbolForChainDescriptor ]
    if( chainDescriptor.bar === self )
    chainDescriptor.bar = null;
  }

  return result;
}

//

function unchain()
{
  var self = this;

  self.inputUnchain();
  self.outputUnchain();

}

//

function consoleIsBarred( output )
{
  _.assert( output === console );
  _.assert( arguments.length === 1, 'expects single argument' );

  var descriptor = output[ symbolForChainDescriptor ];
  if( !descriptor )
  return false;

  return !!descriptor.bar;
}

//

function consoleBar( o )
{
  var self = this;
  var o = _.routineOptions( consoleBar, arguments );

  // debugger;

  if( !o.barLogger )
  o.barLogger = new self.Self({ output : null, name : 'barLogger' });
  if( !o.outputLogger && this.instanceIs() )
  o.outputLogger = this;
  if( !o.outputLogger )
  o.outputLogger = new self.Self();

  /* */

  /* */

  if( o.bar )
  {

    if( o.verbose )
    {
      o.outputLogger.begin({ verbosity : 4 });
      o.outputLogger.log( 'Barring console' );
      o.outputLogger.end({ verbosity : 4 });
    }

    _.assert( !o.barLogger.inputs.length );
    _.assert( !o.barLogger.outputs.length );
    // debugger;
    // _.assert( o.outputLogger.outputs.length === 0 || ( o.outputLogger.outputs.length === 1 && o.outputLogger.outputs[ 0 ] === console ), '{-o.outputLogger-} should have no output' );
    _.assert( !o.outputLoggerHadOutputs );

    o.outputLoggerHadOutputs = o.outputLogger.outputs.slice();

    o.outputLoggerWasChainedToConsole = o.outputLogger.outputUnchain( console );
    o.outputLogger.outputUnchain();

    o.outputLogger.outputTo( console,{ unbarring : 1, combining : 'rewrite' } );

    // o.barLogger.permanentStyle = { fg : 'blue', bg : 'yellow' }; /* xxx */
    o.barLogger.permanentStyle = 'bar.neutral';
    o.barLogger.inputFrom( console,{ barring : 1 } );
    o.barLogger.outputTo( o.outputLogger );

  }
  else
  {

    o.barLogger.unchain();

    o.outputLogger.outputUnchain( console );

    _.assert( o.outputLoggerHadOutputs );

    // if( o.outputLoggerWasChainedToConsole )
    // o.outputLogger.outputTo( console );

    for( var t = 0 ; t < o.outputLoggerHadOutputs.length ; t++ )
    {
      debugger;
      var outputOptions = o.outputLoggerHadOutputs[ t ];
      o.outputLogger.outputTo( outputOptions.output, _.mapOnly( outputOptions, o.outputLogger.outputTo.defaults ) );
    }

  }

/*

     barring       ordinary       unbarring
 console -> barLogger -> outputLogger -> console
   ^
   |
 others

unbarring link is not transitive, but terminating
so no cycle


 console -> barLogger -> outputLogger -> defLogger -> console

*/

  return o;
}

consoleBar.defaults =
{
  outputLogger : null,
  barLogger : null,
  bar : 1,
  verbose : 0,
  outputLoggerWasChainedToConsole : null,
  outputLoggerHadOutputs : null,
}

// --
// test
// --

function _hasInput( input,o )
{
  var self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.mapIs( o ) );
  _.assert( _.objectIs( input ) || _.consoleIs( input ) || _.processIs( input ) );
  _.routineOptions( _hasInput,o );

  for( var d = 0 ; d < self.inputs.length ; d++ )
  {
    if( self.inputs[ d ].input === input )
    {
      if( o.ignoringUnbar && self.inputs[ d ].unbarring )
      continue;
      debugger;
      return true;
    }
  }

  if( o.deep )
  for( var d = 0 ; d < self.inputs.length ; d++ )
  {
    var inputs = self.inputs[ d ].input.inputs;
    if( o.ignoringUnbar && self.inputs[ d ].unbarring )
    continue;
    if( inputs && inputs.length )
    {
      if( _hasInput.call( self.inputs[ d ].input, input, o ) )
      return true;
    }
  }

  return false;
}

_hasInput.defaults =
{
  deep : 1,
  ignoringUnbar : 1,
}

//

function hasInputNotDeep( input )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  return self._hasInput( input,{ deep : 0 } );
}

//

function hasInputDeep( input )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  return self._hasInput( input,{ deep : 1 } );
}

//

function _hasOutput( output,o )
{
  var self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.mapIs( o ) );
  _.assert( _.objectIs( output ) || _.consoleIs( output ) || _.processIs( output ));
  //_.assert( _.objectIs( output ) );
  _.routineOptions( _hasOutput,o );

  for( var d = 0 ; d < self.outputs.length ; d++ )
  {
    if( self.outputs[ d ].output === output )
    {
      if( o.ignoringUnbar && self.outputs[ d ].unbarring )
      continue;
      // debugger;
      return true;
    }
  }

  if( o.deep )
  for( var d = 0 ; d < self.outputs.length ; d++ )
  {
    var outputs = self.outputs[ d ].output.outputs;
    if( o.ignoringUnbar && self.outputs[ d ].unbarring )
    continue;
    if( outputs && outputs.length )
    {
      if( _hasOutput.call( self.outputs[ d ].output, output, o ) )
      return true;
    }
  }

  return false;
}

_hasOutput.defaults =
{
  deep : 1,
  ignoringUnbar : 1,
}

//

function hasOutputNotDeep( output )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  return self._hasOutput( output,{ deep : 0 } );
}

//

function hasOutputDeep( output )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  return self._hasOutput( output,{ deep : 1 } );
}

// --
// etc
// --

function _outputSet( output )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  self.outputTo( output, { combining : 'rewrite' } );

}

//

function _outputGet( output )
{
  var self = this;
  _.assert( self.outputs );
  return self.outputs.length ? self.outputs[ self.outputs.length-1 ].output : null;
}

// --
// var
// --

var symbolForChainDescriptor = Symbol.for( 'chainDescriptor' );
var symbolForLevel = Symbol.for( 'level' );

var Channels =
[
  'log',
  'error',
  'info',
  'warn',
  'debug'
];

var ChangeLevelMethods =
[
  'up',
  'down',
];

// --
// relationships
// --

var Composes =
{

  outputs : [],
  inputs : [],

  isTerminal : 0,

}

var Aggregates =
{
}

var Associates =
{

  output : null,

}

var Statics =
{

  consoleBar : consoleBar,
  consoleIsBarred : consoleIsBarred,

  // var

  Channels : Channels,
  ChangeLevelMethods : ChangeLevelMethods,

  unbarringConsoleOnError : 1

}

// --
// define class
// --

var Supplement =
{

  _writeToChannel : _writeToChannel,
  _writeToChannelUp : _writeToChannelUp,
  _writeToChannelDown : _writeToChannelDown,
  _writeToChannelIn : _writeToChannelIn,

  // routine

  _initChainingMixin : _initChainingMixin,
  __initChainingMixinChannel : __initChainingMixinChannel,

}

//

var Extend =
{

  // chaining

  outputTo : outputTo,
  outputUnchain : outputUnchain,
  _outputToStream : _outputToStream,

  inputFrom : inputFrom,
  inputUnchain : inputUnchain,
  _inputUnchainForeign : _inputUnchainForeign,
  _inputFromStream : _inputFromStream,

  unchain : unchain,

  consoleBar : consoleBar,
  consoleIsBarred : consoleIsBarred,

  // test

  _hasInput : _hasInput,
  hasInputNotDeep : hasInputNotDeep,
  hasInputDeep : hasInputDeep,

  _hasOutput : _hasOutput,
  hasOutputNotDeep : hasOutputNotDeep,
  hasOutputDeep : hasOutputDeep,


  // etc

  _outputSet : _outputSet,
  _outputGet : _outputGet,


  // relationships

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Statics : Statics,

}

//

var Self =
{

  supplement : Supplement,
  extend : Extend,

  _mixin : _mixin,

  name : 'wPrinterChainingMixin',
  nameShort : 'PrinterChainingMixin',

}

Self = _[ Self.nameShort ] = _.mixinMake( Self );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
