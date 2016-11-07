(function _PrinterBase_s_() {

'use strict';

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

  if( typeof wCopyable === 'undefined' )
  try
  {
    require( '../mixin/Copyable.s' );
  }
  catch( err )
  {
    require( 'wCopyable' );
  }

}

//

var symbolForLevel = Symbol.for( 'level' );

//

var _ = wTools;
var Parent = null;
var Self = function wPrinterBase()
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

var init = function( o )
{
  var self = this;

  self.outputs = [];
  _.protoComplementInstance( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  // self.outputTo( null );
  //Object.preventExtensions( self );

  return self;
}

//

var init_static = function()
{
  var proto = this;
  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) );

  for( var m = 0 ; m < proto.outputWriteMethods.length ; m++ )
  if( !proto[ proto.outputWriteMethods[ m ] ] )
  proto._init_static( outputWriteMethods[ m ] );

}

//

var _init_static = function( name )
{
  var proto = this;

  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) )
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ) );

  var nameAct = name + 'Act';
  var nameUp = name + 'Up';
  var nameDown = name + 'Down';

  /* */

  var write = function()
  {
    var args = this.writeDoing( arguments );

    _.assert( _.arrayIs( args ) );

    return this[ nameAct ].apply( this,args );
  }

  /* */

  var writeUp = function()
  {
    var result = this[ name ].apply( this,arguments );

    this.up();

    return result;
  }

  /* */

  var writeDown = function()
  {

    this.down();
    if( arguments.length )
    var result = this[ name ].apply( this,arguments );

    return result;
  }

  proto[ name ] = write;
  proto[ nameUp ] = writeUp;
  proto[ nameDown ] = writeDown;

}

//

var outputTo = function( output,o )
{
  var self = this;
  var o = o || {};
  var combiningAllowed = [ 'rewrite','supplement','apppend','prepend' ];

  _.routineOptions( self.outputTo,o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( output ) || output === null );

  _.assert( !o.combining || combiningAllowed.indexOf( o.combining ) !== -1 );
  _.assert( !o.combining || o.combining === 'rewrite','not implemented combining mode' );
  _.assert( !o.leveling || o.leveling === 'delta','not implemented leveling mode' );

  /* output */

  if( output )
  {

    if( self.outputs.indexOf( output ) !== -1 )
    return false;

    if( self.outputs.length )
    {
      if( self.outputs.length )
      return false;
      else if( o.combining === 'rewrite' )
      self.outputs.splice( 0,self.outputs.length );
    }

    var descriptor = {};
    descriptor.output = output;
    descriptor.methods = {};

    if( !o.combining )
    _.assert( self.outputs.length === 0, 'outputTo : combining if off, multiple outputs are not allowed' );

    self.outputs.push( descriptor );

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
      self[ nameAct ] = null;
      continue;
    }

    _.assert( output[ name ],'outputTo expects output has method',name );

    descriptor.methods[ nameAct ] = _.routineJoin( output,output[ name ] );

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
      self[ nameAct ] = null;
      continue;
    }

    if( output[ name ] && p.leveling === 'delta' )
    descriptor.methods[ nameAct ] = _.routineJoin( output,output[ name ] );
    else
    descriptor.methods[ nameAct ] = function(){};

    self[ nameAct ] = descriptor.methods[ nameAct ]

  }

  return true;
}

outputTo.defaults =
{
  combining : 0,
  leveling : 0,
}

//

var inputFrom = function( input,o )
{
  var self = this;
  var o = o || {};

  _.routineOptions( self.inputFrom,o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( output ) || output === null );

  debugger;

  if( _.routineIs( input.outputTo ) )
  {
    input.outputTo( self,o );
    return;
  }

  debugger;

  /* write */

  for( var m = 0 ; m < self.outputWriteMethods.length ; m++ ) (function()
  {
    var name = self.outputWriteMethods[ m ];

    _.assert( input[ name ],'inputFrom expects input has method',name );

    var original = input[ name ];
    input[ name ] = function()
    {
      debugger;
    }

  })();

}

inputFrom.defaults =
{
  rewriting : 'rewrite',
}

inputFrom.defaults.__proto__ = outputTo.defaults;

//

var writeDoing = function( args )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var result = [ _.str.apply( _,args ) ];

  return result;
}

//

var up = function( dLevel )
{
  var self = this;
  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self._levelSet( self.level+dLevel );

}

//

var down = function( dLevel )
{
  var self = this;
  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self._levelSet( self.level-dLevel );

}

//

var _levelSet = function( level )
{
  var self = this;

  _.assert( level >= 0, '_levelSet : cant go below zero level to',level );
  _.assert( isFinite( level ) );

  var dLevel = level - self[ symbolForLevel ];

  if( dLevel > 0 )
  self.upAct( +dLevel );
  else if( dLevel < 0 )
  self.downAct( -dLevel );

  self[ symbolForLevel ] = level ;

}

//

var _outputSet = function( output )
{
  var self = this;

  _.assert( arguments.length === 1 );

  self.outputTo( output,{ combining : 'rewrite' } );

}

//

var _outputGet = function( output )
{
  var self = this;
  return self.outputs.length ? self.outputs[ self.outputs.length-1 ] : null;
}

// --
// relationships
// --

var Composes =
{
  level : 0,
}

var Aggregates =
{
}

var Associates =
{

  output : null,
  outputs : [],
  outputsDescriptors : [],

}

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

// --
// prototype
// --

var Proto =
{

  // routine

  init : init,
  outputTo : outputTo,

  init_static : init_static,
  _init_static : _init_static,
  writeDoing : writeDoing,

  up : up,
  down : down,

  _levelSet : _levelSet,

  _outputSet : _outputSet,
  _outputGet : _outputGet,

  // var

  outputWriteMethods : outputWriteMethods,
  outputChangeLevelMethods : outputChangeLevelMethods,


  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

wCopyable.mixin( Self );

Self.prototype.init_static();

//

_.accessor
({
  object : Self.prototype,
  names :
  {
    level : 'level',
    output : 'output',
  }
});

//

_.accessorForbid
({
  object : Self.prototype,
  names :
  {
    format : 'format',
  }
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools.PrinterBase = Self;

return Self;

})();
