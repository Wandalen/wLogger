(function _PrinterBase_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let _externalTools = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      _externalTools = 1;
      require( 'wTools' );
    }
    if( !_externalTools )
    require( toolsPath );
  }

  var _global = _global_;
  var _ = _global_.wTools;

  _.include( 'wCopyable' );
  _.include( 'wStringer' );
  _.include( 'wStringsExtra' );

}

//

/**
 * @class wPrinterBase
 */

var _global = _global_;
var _ = _global_.wTools;
var Parent = null;
var Self = function wPrinterBase( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.shortName = 'PrinterBase';

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

// --
// transform
// --

function transform( o )
{
  var self = this;

  _.assertMapHasAll( o, transform.defaults );

  o = self._transformBegin( o );

  if( !o )
  return;

  o = self._transformAct( o );

  _.assert( _.mapIs( o ) );
  _.assert( _.longIs( o.input ) );

  o = self._transformEnd( o );

  return o;
}

transform.defaults =
{
  input : null,
}

//

function _transformBegin( o )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  return o;
}

//

function _transformAct( o )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.mapIs( o ) );
  _.assert( _.longIs( o.input ) );

  o.pure = self._strConcat( o.input );
  o.outputForPrinter = [ o.pure ];
  o.outputForTerminal = [ o.pure ];

  /* !!! remove later */

  _.accessorForbid
  ({
    object : o,
    names :
    {
      output : 'output',
    }
  });

  return o;
}

//

function _transformEnd( o )
{
  _.assert( arguments.length === 1, 'expects single argument' );
  return o;
}

// --
// leveling
// --

// !!! poor description

/**
 * Increases value of logger level property by( dLevel ).
 *
 * If argument( dLevel ) is not specified, increases by one.
 *
 * @example
 * var l = new _.Logger({ output : console });
 * l.up( 2 );
 * console.log( l.level )
 * //returns 2
 * @method up
 * @throws { Exception } If more then one argument specified.
 * @throws { Exception } If( dLevel ) is not a finite number.
 * @memberof wPrinterBase
 */

function up( dLevel )
{
  var self = this;

  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level+dLevel );

}

//

// !!! poor description

/**
 * Decreases value of logger level property by( dLevel ).
 * If argument( dLevel ) is not specified, decreases by one.
 *
 * @example
 * var l = new _.Logger({ output : console });
 * l.up( 2 );
 * l.down( 2 );
 * console.log( l.level )
 * //returns 0
 * @method down
 * @throws { Exception } If more then one argument specified.
 * @throws { Exception } If( dLevel ) is not a finite number.
 * @memberof wPrinterBase
 */

function down( dLevel )
{
  var self = this;

  if( dLevel === undefined )
  dLevel = 1;

  _.assert( arguments.length <= 1 );
  _.assert( isFinite( dLevel ) );

  self.levelSet( self.level-dLevel );

}

//

function levelSet( level )
{
  var self = this;

  _.assert( level >= 0, 'levelSet : cant go below zero level to',level );
  _.assert( isFinite( level ) );

  var dLevel = level - self[ symbolForLevel ];

  self[ symbolForLevel ] = level ;

}

// --
// etc
// --

function write()
{
  var self = this;

  var o = self.transform({ input : arguments });

  _.assert( o.outputForPrinter );

  return self;
}

//

function _strConcat( args )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( !_.strConcat )
  return _.str.apply( _,args );

  var optionsForStr =
  {
    linePrefix : self._prefix,
    linePostfix : self._postfix,
  }

  var result = _.strConcat( args, optionsForStr );

  return result;
}

//
//
// function canPrintFrom( src )
// {
//   var self = this;
//
//   if( !_.objectIs( src ) )
//   return false;
//
//   if( _.routineIs( src._print ) && _.routineIs( src._print.makeIterator ) )
//   return true;
//
//   // if( _.routineIs( src.print ) )
//   // return true;
//
//   return false;
// }
//
// //
//
// function printFrom( src )
// {
//   var self = this;
//
//   _.assert( arguments.length === 1, 'expects single argument' );
//   _.assert( _.routineIs( src._print ) );
//   _.assert( _.routineIs( src._print.makeIterator ) );
//   _.assert( src._print.length === 2 );
//
//   var iterator = src._print.makeIterator({ printer : self });
//   var iteration = iterator.iterationNew();
//
//   Object.preventExtensions( iterator );
//   Object.preventExtensions( iteration );
//
//   src._print( iteration,iterator );
//
// }

// --
// relations
// --

var symbolForLevel = Symbol.for( 'level' );

var Composes =
{

  name : '',
  level : 0,

}

var Aggregates =
{
}

var Associates =
{
}

var Accessors =
{
  level : 'level',
}

// --
// define class
// --

var Proto =
{

  // routine

  init : init,

  // transform

  transform : transform,
  _transformBegin : _transformBegin,
  _transformAct : _transformAct,
  _transformEnd : _transformEnd,

  // leveling

  up : up,
  down : down,
  levelSet : levelSet,

  // etc

  write : write,
  _strConcat : _strConcat,

  // canPrintFrom : canPrintFrom,
  // printFrom : printFrom,

  // relations

  /* constructor * : * Self, */
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Accessors : Accessors,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
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
