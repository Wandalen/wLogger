(function _aChainingMixin_s_() {

'use strict';xxx

var isBrowser = true;
if( typeof module !== 'undefined' )
{

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  isBrowser = false;

}

var _ = wTools;

//

function mixin( constructor )
{

  var dst = constructor.prototype;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( constructor ) );

  _.mixin
  ({
    dst : dst,
    mixin : Self,
  });

  /* */

  _.accessor
  ({
    object : dst,
    names :
    {
      output : 'output',
    }
  });

  /* */

  _.accessorForbid
  ({
    object : dst,
    names :
    {
      format : 'format',
    }
  });

  /* */

  dst._initChainingMixin();

}

//

function _initChainingMixin()
{
  var proto = this;
  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) );

  for( var m = 0 ; m < proto.outputWriteMethods.length ; m++ )
  proto.__initChainingMixinWrite( outputWriteMethods[ m ] );

}

//

function __initChainingMixinWrite( name )
{
  var proto = this;

  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) )
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ) );

  if( proto[ name ] )
  return;

  var nameAct = name + 'Act';
  var nameUp = name + 'Up';
  var nameDown = name + 'Down';

  /* */

  function write()
  {

    var args = arguments;
    // var args = this.write.apply( this,arguments );

    // debugger;
    // this[ nameAct ].apply( this,args );

    this._writeToChannel( name,args );

    return this;
  }

  /* */

  function writeUp()
  {

    this._writeToChannelUp( name,arguments );

    // this.up();
    //
    // this.begin( 'head' );
    //
    // var result = this[ name ].apply( this,arguments );
    //
    // this.end( 'head' );

    return this;
  }

  /* */

  function writeDown()
  {

    this._writeToChannelDown( name,arguments );

    // this.begin( 'tail' );
    //
    // var result = this[ name ].apply( this,arguments );
    //
    // this.end( 'tail' );
    //
    // this.down();

    return this;
  }

  /* */

  proto[ name ] = write;
  proto[ nameUp ] = writeUp;
  proto[ nameDown ] = writeDown;

}

//

function _writeToChannel( channelName,args )
{
  var self = this;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( channelName ) );
  _.assert( _.arrayLike( args ) );

  var args = this.write.apply( this,args );

  console[ channelName ].apply( console,args );

}

//

function _writeToChannelUp( channelName,args )
{
  var self = this;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( channelName ) );
  _.assert( _.arrayLike( args ) );

  this.up();

  this.begin( 'head' );
  self._writeToChannel( channelName,args );
  this.end( 'head' );

}

//

function _writeToChannelDown( channelName,args )
{
  var self = this;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( channelName ) );
  _.assert( _.arrayLike( args ) );

  this.begin( 'tail' );
  self._writeToChannel( channelName,args );
  this.end( 'tail' );

  this.down();

}

// --
// write
// --

// function write()
// {
//   var self = this;
//
//   var args = self._writeBegin( arguments );
//
//   _.assert( _.arrayIs( args ) );
//
//   if( self.onWrite )
//   self.onWrite( args[ 0 ] );
//
//   return args;
// }

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
 * var l = new wLogger();
 * l.outputTo( logger, { combining : 'rewrite' } ); //returns true
 * logger._prefix = '--';
 * l.log( 'abc' );//logger prints '--abc'
 *
 * @example
 * var l1 = new wLogger();
 * var l2 = new wLogger();
 * l1.outputTo( logger, { combining : 'rewrite' } );
 * l2.outputTo( l1, { combining : 'rewrite' } );
 * logger._prefix = '*';
 * logger._postfix = '*';
 * l2.log( 'msg from l2' );//logger prints '*msg from l2*'
 *
 * @example
 * var l1 = new wLogger();
 * var l2 = new wLogger();
 * var l3 = new wLogger();
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
 * var l1 = new wLogger();
 * l.outputTo( logger, { combining : 'rewrite', leveling : 'delta' } );
 * logger.up( 2 );
 * l.up( 1 );
 * logger.log( 'aaa\nbbb' );
 * l.log( 'ccc\nddd' );
 * //logger prints
 * // ---aaa
 * // ---bbb
 * // ----ccc
 * // -----ddd
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
  var o = o || {};
  var combiningAllowed = [ 'rewrite','supplement','append','prepend' ];

  _.routineOptions( self.outputTo,o );
  _.assertNoDebugger( arguments.length === 1 || arguments.length === 2 );
  _.assertNoDebugger( _.objectIs( output ) || output === null );

  _.assertNoDebugger( !o.combining || combiningAllowed.indexOf( o.combining ) !== -1, 'unknown combining mode',o.combining );
  // _.assert( !o.combining || o.combining === 'rewrite'|| o.combining === 'append' || o.combining === 'prepend','not implemented combining mode' );
  _.assertNoDebugger( !o.leveling || o.leveling === 'delta','not implemented leveling mode' );

  /* output */

  if( output )
  {

    // if( self.outputs.indexOf( output ) !== -1 )
    // return false;

    _.assert( self !== output, 'outputTo: Adding of own object to output is not allowed' );

    if( o.combining !== 'rewrite' )
    if( self.hasOutput( output ) )
    throw _.err( 'outputTo: This output already exists in outputs', output );


    if( self.inputs )
    if( self._hasInput( output ) )
    throw _.err( 'outputTo: This object already exists in inputs chain', output );

    if( !output.inputs )
    output.inputs = [];

    if( self.outputs.length )
    {
      if( o.combining === 'supplement' )
      return false;
      else if( o.combining === 'rewrite' )
      self.outputs.splice( 0,self.outputs.length );
    }

    var descriptor = {};
    descriptor.output = output;
    descriptor.methods = {};

    var descriptorInput = {};
    descriptorInput.input = self;
    descriptorInput.methods = {};

    if( !o.combining )
    _.assert( self.outputs.length === 0, 'outputTo : combining if off, multiple outputs are not allowed' );

    if( o.combining === 'prepend' )
    {
      self.outputs.unshift( descriptor );
      output.inputs.unshift( descriptorInput );
    }
    else
    {
      self.outputs.push( descriptor );
      output.inputs.push( descriptorInput );
    }

  }
  else
  {
    if( self.outputs.length )
    {
      if( o.combining === 'rewrite' )
      {
        for( var d = 0; d < self.outputs.length ; d++ )
        self.outputToUnchain( self.outputs[ d ].output );

        self.outputs.splice( 0,self.outputs.length );
      }
      else return false;
    }
  }

  /* write */

  for( var m = 0 ; m < self.outputWriteMethods.length ; m++ )
  {

    var name = self.outputWriteMethods[ m ];
    var nameAct = name + 'Act';

    // if( o.combining === 'supplement' && _.routineIs( self[ nameAct ] ) )
    // continue;

    if( output === null )
    {
      //debugger;
      self[ nameAct ] = function(){};
      // self[ nameAct ] = null;
      continue;
    }

    _.assertNoDebugger( output[ name ],'outputTo expects output has method',name );

    descriptor.methods[ nameAct ] = _.routineJoin( output,output[ name ] );
    // descriptorInput.methods[ name ] = self[ name ];

    if( self.outputs.length > 1 ) ( function()
    {
      var n = nameAct;
      self[ n ] = function()
      {
        for( var d = 0 ; d < this.outputs.length ; d++ )
        this.outputs[ d ].methods[ n ].apply( this,arguments );
      }
    })()
    else
    {
      self[ nameAct ] = descriptor.methods[ nameAct ];
    }

  }

  /* change level */

  for( var m = 0 ; m < self.outputChangeLevelMethods.length ; m++ )
  {

    var name = self.outputChangeLevelMethods[ m ];
    var nameAct = name + 'Act';

    // if( o.combining === 'supplement' && _.routineIs( self[ nameAct ] ) )
    // continue;

    if( output === null )
    {
      //debugger;
      self[ nameAct ] = function(){};
      //self[ nameAct ] = null;
      continue;
    }

    if( output[ name ] && o.leveling === 'delta' )
    descriptor.methods[ nameAct ] = _.routineJoin( output,output[ name ] );
    else
    descriptor.methods[ nameAct ] = function(){};
    // descriptorInput.methods[ name ] = self[ name ];

    if( self.outputs.length > 1 ) ( function()
    {
      var n = nameAct;
      self[ n ] = function()
      {
        for( var d = 0 ; d < this.outputs.length ; d++ )
        this.outputs[ d ].methods[ n ].apply( this,arguments );
      }
    })()
    else
    {
      self[ nameAct ] = descriptor.methods[ nameAct ]
    }

  }

  return true;
}

outputTo.defaults =
{
  combining : 0,
  leveling : 0,
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
 * var l1 = new wLogger();
 * var l2 = new wLogger();
 * var l3 = new wLogger();
 * logger.outputTo( l1, { combining : 'rewrite' } );
 * logger.outputTo( l2, { combining : 'append' } );
 * logger.outputTo( l3, { combining : 'append' } );
 * l1._prefix = '*';
 * l2._prefix = '**';
 * l3._prefix = '***';
 *
 * logger.outputToUnchain( l1 ); //returns true
 * logger.outputToUnchain( l1 ); //returns false because l1 not exists in the list anymore
 * logger.log( 'msg from logger' );
 * //l2 prints '**msg from logger'
 * //l3 prints '***msg from logger'
 *
 * @method outputToUnchain
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( output ) is not a Object.
 * @throws { Exception } If outputs list is empty.
 * @memberof wPrinterMid
 *
 */

function outputToUnchain( output )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.objectIs( output ) );
  _.assert( self.outputs.length, 'outputToUnchain : outputs list is empty' );
  _.assert( self !== output, 'outputToUnchain: Can not remove itself from outputs' );

  for( var i = 0; i < self.outputs.length; i++ )
  {
    if( self.outputs[ i ].output === output )
    {
      self.outputs.splice( i, 1 );
      if( self.outputs.length && !output.inputs )
      return true;
      break;
    }
  }

  if( output.inputs )
  for( var i = 0; i < output.inputs.length; i++ )
  {
    if( output.inputs[ i ].input === self )
    {
      output.inputs.splice( i, 1 );
      if( self.outputs.length )
      return true;
      break;
    }
  }

  if( !self.outputs.length )
  {
    for( var m = 0 ; m < self.outputWriteMethods.length ; m++ )
    {
      var nameAct = self.outputWriteMethods[ m ] + 'Act';
      self[ nameAct ] =  function(){};
    }

    for( var m = 0 ; m < self.outputChangeLevelMethods.length ; m++ )
    {
      var nameAct = self.outputChangeLevelMethods[ m ] + 'Act';
      self[ nameAct ] =  function(){};
    }

    return true;
  }

  return false;
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
 * var l = new wLogger();
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
   var o = o || {};
   var combiningAllowed = [ 'rewrite','append','prepend' ];

   _.routineOptions( self.inputFrom,o );
   _.assert( arguments.length === 1 || arguments.length === 2 );
   _.assert( _.objectIs( input ) );

  //  debugger;

   if( _.routineIs( input.outputTo ) )
   {
     return input.outputTo( self,o );
   }

   _.assert( !o.combining || combiningAllowed.indexOf( o.combining ) !== -1, 'unknown combining mode',o.combining );

  //  debugger;

   /* input check */
   if( o.combining !== 'rewrite' )
   if( self.hasInput( input ) )
   throw _.err( 'inputFrom: This input already exists in logger inputs', input );

   /*recursive outputs check*/
   if( self._hasOutput( input ) )
   throw _.err( 'inputFrom: This input already exists in chain', input );


   if( !input.outputs )
   {
     input.outputs = [];
   }

   if( input.outputs.length )
   {
     if( o.combining === 'rewrite' )
     input.outputs.splice( 0,input.outputs.length );
   }

   var descriptor = {};
   descriptor.output = self;
   descriptor.methods = {};

   if( o.combining === 'prepend' )
   input.outputs.unshift( descriptor );
   else
   input.outputs.push( descriptor );

   if( !input._original )
   input._original = {};

   for( var m = 0 ; m < self.outputWriteMethods.length ; m++ ) ( function()
   {
     var name = self.outputWriteMethods[ m ];
     _.assert( input[ name ],'inputFrom expects input has method',name );

     descriptor.methods[ name ] = _.routineJoin( self, self[ name ] );
     if( !input._original[ name ] )
     input._original[ name ] = _.routineJoin( input, input[ name ]);

     input[ name ] = function()
     {
       input._original[ name ].apply( input, arguments );
       for( var d = 0 ; d < input.outputs.length ; d++ )
       input.outputs[ d ].methods[ name ].apply( self, arguments );
     }
   })();

   self.inputs.push( { input : input, methods : input._original } );

   return true;
 }

inputFrom.defaults =
{
  combining : 'append',
}

inputFrom.defaults.__proto__ = outputTo.defaults;

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
 * logger.inputFromUnchain( console );
 * logger._prefix = '*';
 * console.log( 'msg for logger' ); //console prints 'msg for logger'
 *
 * @example
 * var l = new wLogger();
 * logger.inputFrom( l, { combining : 'append' } );
 * logger._prefix = '*';
 * l.log( 'msg for logger' ) //logger prints '*msg for logger'
 * logger.inputFromUnchain( l );
 * l.log( 'msg for logger' ) //l prints 'msg for logger'
 *
 * @method inputFromUnchain
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If( input ) is not a Object.
 * @memberof wPrinterMid
 *
 */

function inputFromUnchain( input )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.objectIs( input ) || input === null );

  if( _.routineIs( input.outputToUnchain ) )
  {
    return input.outputToUnchain( self );
  }

  for( var i = 0; i < self.inputs.length ; i++ )
  if( self.inputs[ i ].input === input )
  {
    for( var d = 0; d < input.outputs.length ; d++ )
    if( input.outputs[ d ].output === self )
    input.outputs.splice( d, 1 );

    if( !input.outputs.length )
    {
      for( var m = 0 ; m < self.outputWriteMethods.length ; m++ ) (function()
      {
        var name = self.outputWriteMethods[ m ];

        _.assert( input[ name ],'inputFromUnchain expects input has method',name );

        input[ name ] = self.inputs[ i ].methods[ name ];
      })();

      delete input.outputs;
      delete input._original;
    }

    // for( var m = 0 ; m < self.outputChangeLevelMethods.length ; m++ ) (function()
    // {
    //   var name = self.outputChangeLevelMethods[ m ];
    //   input[ name ] = function(){};
    // })();

    self.inputs.splice( i, 1 );

    return true;
  }

  return false;
}

//

function hasInput( input )
{
  _.assert( _.objectIs( input ) );

  var self = this;

  for( var d = 0; d < self.inputs.length ; d++ )
  if( self.inputs[ d ].input === input )
  return true;

  return false;
}

//

function _hasInput( input )
{
  for( var d = 0 ; d < this.inputs.length ; d++ )
  {
    if( this.inputs[ d ].input === input )
    {
      return true;
    }
  }
  for( var d = 0 ; d < this.inputs.length ; d++ )
  {
    var inputs = this.inputs[ d ].input.inputs;
    if( inputs && inputs.length )
    {
      if( _hasInput.call( this.inputs[ d ].input, input ) )
      return true;
    }
  }
  return false;
}

//

function hasOutput( output )
{
  _.assert( _.objectIs( output ) );

  var self = this;

  for( var d = 0; d < self.outputs.length ; d++ )
  if( self.outputs[ d ].output === output )
  return true;

  return false;
}

//

function _hasOutput( output )
{
  for( var d = 0 ; d < this.outputs.length ; d++ )
  {
    if( this.outputs[ d ].output === output )
    {
      return true;
    }
  }
  for( var d = 0 ; d < this.outputs.length ; d++ )
  {
    var outputs = this.outputs[ d ].output.outputs;
    if( outputs && outputs.length )
    {
      if( _hasOutput.call( this.outputs[ d ].output, output ) )
      return true;
    }
  }
  return false;
}

//

function _outputSet( output )
{
  var self = this;

  _.assert( arguments.length === 1 );

  self.outputTo( output,{ combining : 'rewrite' } );

}

//

function _outputGet( output )
{
  var self = this;
  return self.outputs.length ? self.outputs[ self.outputs.length-1 ].output : null;
}

// --
// relationships
// --

var outputWriteMethods =
[
  'log',
  'error',
  'info',
  'warn',
];

var outputChangeLevelMethods =
[
  'up',
  'down',
];

var symbolForLevel = Symbol.for( 'level' );

var Composes =
{

  outputs : [],
  inputs : [],

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
  // var

  outputWriteMethods : outputWriteMethods,
  outputChangeLevelMethods : outputChangeLevelMethods,

}

// --
// proto
// --

var Supplement =
{

  _writeToChannel : _writeToChannel,
  _writeToChannelUp : _writeToChannelUp,
  _writeToChannelDown : _writeToChannelDown,

  // routine

  _initChainingMixin : _initChainingMixin,
  __initChainingMixinWrite : __initChainingMixinWrite,

}

var Extend =
{

  // chaining

  outputTo : outputTo,
  outputToUnchain : outputToUnchain,

  inputFrom : inputFrom,
  inputFromUnchain : inputFromUnchain,

  hasInput : hasInput,
  _hasInput : _hasInput,
  hasOutput : hasOutput,
  _hasOutput : _hasOutput,

  _outputSet : _outputSet,
  _outputGet : _outputGet,


  // relationships

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Statics : Statics,

}

var Self =
{

  Supplement : Supplement,
  Extend : Extend,

  mixin : mixin,

  name : 'wPrinterChainingMixin',
  nameShort : 'PrinterChainingMixin',

}

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
