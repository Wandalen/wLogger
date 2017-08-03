(function _PrinterMid_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof wPrinterMid !== 'undefined' )
  return;

  if( typeof wPrinterBase === 'undefined' )
  require( './PrinterBase.s' );

  require( './aChainingMixin.s' )

  var _ = wTools;

  _.include( 'wCopyable' );

}

//

/**
 * @class wPrinterMid
 */

var _ = wTools;
var Parent = wPrinterBase;
var Self = function wPrinterMid( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterMid';

// --
// routines
// --

function init( o )
{
  var self = this;
  var o = o || {};

  _.assert( arguments.length === 0 | arguments.length === 1 );

  if( Config.debug )
  if( o.sourceFilePath === undefined )
  o.sourceFilePath = _.diagnosticStack( 2 );

  Parent.prototype.init.call( self,o );

  self.levelSet( self.level );

}

// --
// etc
// --

function levelSet( level )
{
  var self = this;

  Parent.prototype.levelSet.call( self,level );

  var level = self[ symbolForLevel ];

  self._prefix = _.strTimes( self._dprefix || '',level );
  self._postfix = _.strTimes( self._dpostfix|| '',level );

}

//

function _writeBegin( args )
{
  var self = this;

  _.assert( arguments.length === 1 );

  Parent.prototype._writeBegin.call( self,args );

  self._minesDetonate();

}

// --
// attributing
// --

function _begin( key,val )
{
  var self = this;

  _.assert( arguments.length === 2 );
  _.assert( _.strIs( key ),'expects string ( key ), got',_.strTypeOf( key ) );

  if( val === undefined )
  {
    _.assert( 0,'value expected' );
    self._end( key,val );
    return self;
  }

  // if( key === 'verbosity' )
  // _.assert( val <= 0 );

  if( self.attributes[ key ] !== undefined )
  {
    self._attributesStacks[ key ] = self._attributesStacks[ key ] || [];
    self._attributesStacks[ key ].push( self.attributes[ key ] );
  }

  self.attributes[ key ] = val;

  return self;
}

//

function begin()
{
  var self = this;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var argument = arguments[ a ];

    if( _.objectIs( argument ) )
    {
      for( var key in argument )
      self._begin( key,argument[ key ] )
      return;
    }

    self._begin( argument,1 );
  }

  return self;
}

//

function _end( key,val )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( key ) );

  // if( val === undefined )
  // {
  //   self._end( key,val );
  //   return self;
  // }

  if( val !== undefined )
  _.assert
  (
    val === self.attributes[ key ],
    '( begin ) does not have complemented ( end )' +
    '\nbegin : ' + _.toStr( self.attributes[ key ] ),
    '\nend : ' + _.toStr( val ),
    '\nlength : ' + ( self._attributesStacks[ key ] ? self._attributesStacks[ key ].length : 0 )
  );

  if( self._attributesStacks[ key ] )
  {
    self.attributes[ key ] = self._attributesStacks[ key ].pop();
    if( !self._attributesStacks[ key ].length )
    delete self._attributesStacks[ key ];
  }
  else
  {
    delete self.attributes[ key ];
  }

  return self;
}

//

function end()
{
  var self = this;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var argument = arguments[ a ];

    if( _.objectIs( argument ) )
    {
      for( var key in argument )
      self._end( key,argument[ key ] )
      return;
    }

    self._end( argument )
  }

  return self;
}

// --
// verbosity
// --

function verbosityPush( src )
{
  var self = this;

  if( !_.numberIs( src ) )
  src = src ? 1 : 0;

  _.assert( arguments.length === 1 );

  self._verbosityStack.push( self.verbosity );

  self.verbosity = src;

}

//

function verbosityPop()
{
  var self = this;

  _.assert( arguments.length === 0 );

  self.verbosity = self._verbosityStack.pop();

}

//

function verbosityReserve( args )
{
  var self = this;

  if( !self.usingVerbosity )
  return Infinity;

  return self._verbosityReserve();
}

//

function _verbosityReserve()
{
  var self = this;

  _.assert( arguments.length === 0 );

  if( self.attributes.verbosity === undefined )
  return Infinity;

  if( self.verbosity === null )
  return Infinity;

  return self.verbosity + self.attributes.verbosity + 1;
}

//

function verboseEnough( args )
{
  var self = this;

  if( !self.usingVerbosity )
  return true;

  return self._verboseEnough();
}

//

function _verboseEnough()
{
  var self = this;

  _.assert( arguments.length === 0 );

  return self._verbosityReserve() > 0;
}

//

function _verbosityReport()
{
  var self = this;

  console.log( 'logger.verbosity',self.verbosity );
  console.log( 'logger.attributes.verbosity',self.attributes.verbosity );
  console.log( self.verboseEnough() ? 'Verbose enough!' : 'Not enough verbose!'  );

}

// --
// mine
// --

function mine( name )
{
  var self = this;
  var mine = Object.create( null );

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ) );

  mine.name = name;
  mine.after = [];
  mine.logger = self;
  mine.autoFinit = 1;
  mine.detonated = 0;
  mine.log = function log()
  {
    if( this.logger.verboseEnough )
    this.after.push([ 'log',arguments ]);
  }

  self._mines[ name ] = mine;

  return mine;
}

//

function _minesDetonate()
{
  var self = this;
  var result = Object.create( null );

  for( var m in self._mines )
  {
    var mine = self._mines[ m ];
    if( !mine.detonated )
    self.mineDetonate( mine );
  }

  return result;
}

//

function mineDetonate( mine )
{
  var self = this;

  if( _.strIs( mine ) )
  mine = self._mines[ mine ];

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( mine ) );

  mine.detonated = 1;

  for( var a = 0 ; a < mine.after.length ; a++ )
  {
    var after = mine.after[ a ];
    self[ after[ 0 ] ].apply( self,after[ 1 ] );
  }

  if( mine.autoFinit )
  self.mineFinit( mine );

  return self;
}

//

function mineFinit( mine )
{
  var self = this;

  if( _.strIs( mine ) )
  mine = self._mines[ mine ];

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( mine ) );
  _.assert( self._mines[ mine.name ] === mine );

  Object.freeze( mine );
  delete self._mines[ mine.name ];

  return self;
}

// --
// relationships
// --

var symbolForLevel = Symbol.for( 'level' );

var Composes =
{

  _prefix : '',
  _postfix : '',

  _dprefix : '  ',
  _dpostfix : '',

  _verbosityStack : [],
  verbosity : null,
  usingVerbosity : 1,

  _attributesStacks : {},
  attributes : {},
  _mines : {},

}

if( Config.debug )
Composes.sourceFilePath = null;

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


  // etc

  levelSet : levelSet,
  _writeBegin : _writeBegin,


  // attributing

  _begin : _begin,
  begin : begin,
  _end : _end,
  end : end,


  // verbosity

  verbosityPush : verbosityPush,
  verbosityPop : verbosityPop,
  verbosityReserve : verbosityReserve,
  _verbosityReserve : _verbosityReserve,
  verboseEnough : verboseEnough,
  _verboseEnough : _verboseEnough,
  _verbosityReport : _verbosityReport,


  // mine

  mine : mine,
  _minesDetonate : _minesDetonate,
  mineDetonate : mineDetonate,
  mineFinit : mineFinit,


  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.prototypeMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.assert( Self.prototype.init === init );

//

_.accessorForbid
({
  object : Self.prototype,
  names :
  {
    format : 'format',
    tags : 'tags',
  }
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

// debugger;
// var x = new Self();
// debugger;

})();
