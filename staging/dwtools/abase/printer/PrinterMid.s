(function _PrinterMid_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './PrinterBase.s' );

  var _ = _global_.wTools;

  require( './aChainer.s' );
  require( './aChainingMixin.s' )

  _.include( 'wCopyable' );

}

//

/**
 * @class wPrinterMid
 */

var _global = _global_; var _ = _global_.wTools;
var Parent = _.PrinterBase;
var Self = function wPrinterMid( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.shortName = 'PrinterMid';

// --
// routines
// --

function init( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 | arguments.length === 1 );

  if( Config.debug )
  if( o.scriptStack === undefined )
  o.scriptStack = _.diagnosticStack( 2 );

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

  self._prefix = _.strDup( self._dprefix || '',level );
  self._postfix = _.strDup( self._dpostfix || '',level );

}

//

function _transformBegin( o )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( self.onTransformBegin )
  o = self.onTransformBegin( o );

  if( !o )
  return;

  if( !self.verboseEnough() )
  return;

  o = Parent.prototype._transformBegin.call( self, o );

  if( !o )
  return;

  self._laterActualize();

  return o;
}

//

function _transformEnd( o )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( self.onTransformEnd )
  self.onTransformEnd( o );

  o = Parent.prototype._transformEnd.call( self, o );

  if( !o )
  return;

  return o;
}

// --
// attributing
// --

function _begin( key,val )
{
  var self = this;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( key ),'expects string {-key-}, got',_.strTypeOf( key ) );

  if( val === undefined )
  {
    _.assert( 0,'value expected' );
    self._end( key,val );
    return self;
  }

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

  if( val !== undefined )
  _.assert
  (
    val === self.attributes[ key ],
    () => self._attributeError( key, self.attributes[ key ], val )
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

//

function _rbegin( key, val )
{
  var self = this;
  var attribute = self.attributes[ key ];

  if( attribute === undefined )
  {
    self._begin( key, 0 );
    attribute = 0;
  }

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( key ),'expects string {-key-}, got', () => _.strTypeOf( key ) );
  _.assert( _.numberIs( val ),'expects number {-val-}, got', () => _.strTypeOf( val ) );
  _.assert( _.numberIs( attribute ), () => _.args( 'expects number, but attribute', _.strQuote( key ), 'had value', _.strQuote( attribute ) ) );

  return self._begin( key, val + attribute )
}

//

function rbegin()
{
  var self = this;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var argument = arguments[ a ];

    if( _.objectIs( argument ) )
    {
      for( var key in argument )
      self._rbegin( key,argument[ key ] )
      return;
    }

    self._rbegin( argument,1 );
  }

  return self;
}

//

function _rend( key,val )
{
  var self = this;
  var attributeStack = self._attributesStacks[ key ];

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( key ) );
  _.assert( _.numberIs( val ) );

  _.assert
  (
    _.arrayIs( attributeStack ) && _.numberIs( attributeStack[ attributeStack.length-1 ] ),
    () => self._attributeError( key, undefined, val )
  );

  var attribute = attributeStack[ attributeStack.length-1 ];
  var val = attribute + val;

  self._end( key, val );

  return self;
}

//

function rend()
{
  var self = this;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var argument = arguments[ a ];

    if( _.objectIs( argument ) )
    {
      for( var key in argument )
      self._rend( key,argument[ key ] )
      return;
    }

    self._rend( argument )
  }

  return self;
}

//

function _attributeError( key, begin, end )
{
  var self = this;

  debugger;

  return _.err
  (
    '{-begin-} does not have complemented {-end-}' +
    '\nkey : ' + _.toStr( key ) +
    '\nbegin : ' + _.toStr( begin ) +
    '\nend : ' + _.toStr( end ) +
    '\nlength : ' + ( self._attributesStacks[ key ] ? self._attributesStacks[ key ].length : 0 )
  );

}

// --
// verbosity
// --

function verbosityPush( src )
{
  var self = this;

  if( !_.numberIs( src ) )
  src = src ? 1 : 0;

  _.assert( arguments.length === 1, 'expects single argument' );

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

function verboseEnough()
{
  var self = this;

  _.assert( arguments.length === 0 );

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
// later
// --

function later( name )
{
  var self = this;
  var later = Object.create( null );

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( name ) );

  later.name = name;
  later.after = [];
  later.logger = self;
  later.autoFinit = 1;
  later.detonated = 0;
  later.log = function log()
  {
    if( this.logger.verboseEnough )
    this.after.push([ 'log',arguments ]);
  }

  self._mines[ name ] = later;

  return later;
}

//

function _laterActualize()
{
  var self = this;
  var result = Object.create( null );

  for( var m in self._mines )
  {
    var later = self._mines[ m ];
    if( !later.detonated )
    self.laterActualize( later );
  }

  return result;
}

//

function laterActualize( later )
{
  var self = this;

  if( _.strIs( later ) )
  later = self._mines[ later ];

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.mapIs( later ) );

  later.detonated = 1;

  for( var a = 0 ; a < later.after.length ; a++ )
  {
    var after = later.after[ a ];
    self[ after[ 0 ] ].apply( self,after[ 1 ] );
  }

  if( later.autoFinit )
  self.laterFinit( later );

  return self;
}

//

function laterFinit( later )
{
  var self = this;

  if( _.strIs( later ) )
  later = self._mines[ later ];

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.mapIs( later ) );
  _.assert( self._mines[ later.name ] === later );

  Object.freeze( later );
  delete self._mines[ later.name ];

  return self;
}

// --
// relations
// --

var symbolForLevel = Symbol.for( 'level' );

var Composes =
{

  verbosity : null,
  usingVerbosity : 1,

  onTransformBegin : null,
  onTransformEnd : null,

  attributes : Object.create( null ),

}

if( Config.debug )
Composes.scriptStack = null;

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{

  _prefix : '',
  _postfix : '',

  _dprefix : '  ',
  _dpostfix : '',

  _verbosityStack : [],

  _attributesStacks : Object.create( null ),
  _mines : Object.create( null ),

}

var Forbids =
{
  format : 'format',
  tags : 'tags',
}

// --
// define class
// --

var Proto =
{

  // routine

  init : init,

  // etc

  levelSet : levelSet,
  _transformBegin : _transformBegin,
  _transformEnd : _transformEnd,

  // attributing

  _begin : _begin,
  begin : begin,
  _end : _end,
  end : end,

  _rbegin : _rbegin,
  rbegin : rbegin,
  _rend : _rend,
  rend : rend,

  _attributeError : _attributeError,

  // verbosity

  verbosityPush : verbosityPush,
  verbosityPop : verbosityPop,
  verbosityReserve : verbosityReserve,
  _verbosityReserve : _verbosityReserve,
  verboseEnough : verboseEnough,
  _verboseEnough : _verboseEnough,
  _verbosityReport : _verbosityReport,

  // later

  later : later,
  _laterActualize : _laterActualize,
  laterActualize : laterActualize,
  laterFinit : laterFinit,

  // relations

  /* constructor * : * Self, */
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Forbids : Forbids,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.assert( Self.prototype.init === init );

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
