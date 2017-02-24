(function _PrinterBase_s_() {

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
{
  isBrowser = false;
  if( typeof wPrinterBase !== 'undefined' )
  return;

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wCopyable' );

}

//

/**
 * @class wPrinterBase
 */

var _ = wTools;
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

Self.nameShort = 'PrinterBase';

//

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
// write
// --

function write()
{
  var self = this;

  var args = self._writeBegin( arguments );

  _.assert( _.arrayIs( args ) );

  if( self.onWrite )
  self.onWrite( args );

  return args;
}

//

function _writeBegin( args )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var result = [ self._strConcat( args ) ];

  return result;
}

//

function _strConcat( args )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( !_.strConcat )
  return _.str.apply( _,args );

  var optionsForStr =
  {
    linePrefix : self._prefix,
    linePostfix : self._postfix,
  }

  var result = _.strConcat.apply( optionsForStr,args );

  return result;
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
 * var l = new wLogger();
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
 * var l = new wLogger();
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

function logFrom( src )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( src.toStr ) );
  _.assert( _.routineIs( src.toStr.makeIterator ) );
  _.assert( _.routineIs( src.toStr.makeIteration ) );

  var iterator = src.toStr.makeIterator();
  var iteration = src.toStr.makeIteration();

  var _toStr = iterator._toStr;
  var level = iteration.level;

  iterator._toStr = function _toStrFrom( iteration,iterator )
  {

    if( level !== iteration.level )
    self.levelSet( iteration.level );

    level = iteration.level;

    var result = this._toStr( iteration,iterator );

    if( level === iteration.level )
    self.log( result );

    return result;
  }

  src._toStr( iteration,iterator );

}

// --
// relationships
// --

var symbolForLevel = Symbol.for( 'level' );

var Composes =
{

  level : 0,
  onWrite : null,

}

var Aggregates =
{
}

var Associates =
{
}

// --
// prototype
// --

var Proto =
{

  // routine

  init : init,


  // write

  write : write,
  _writeBegin : _writeBegin,
  _strConcat : _strConcat,


  // leveling

  up : up,
  down : down,
  levelSet : levelSet,


  // etc

  logFrom : logFrom,


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

//

_.accessor
({
  object : Self.prototype,
  names :
  {
    level : 'level',
  }
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
