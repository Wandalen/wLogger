(function _PrinterMid_s_(){

'use strict';

var isBrowser = true;
if( typeof module !== 'undefined' )
{

  isBrowser = false;

  if( typeof wPrinterBase === 'undefined' )
  require( './PrinterBase.s' )

}

//

var _ = wTools;
var Parent = wPrinterBase;
var Self = function wPrinterMid()
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

  Parent.prototype.init.call( self,o );

}

//

var Chalk;
var _writeDoingChalk = function( str )
{
  var self = this;

  _.assert( arguments.length === 1 );

  if( Chalk === undefined && typeof module !== 'undefined' )
  try
  {
    Chalk = require( 'chalk' );
  }
  catch( err ) 
  {
    Chalk = null;
  }

  var result = '';
  var i = 0;
  str = str.split( '#' );

  while( i < str.length )
  {
    var options =  str[ i ].split( ' : ' );
    var style = options[ 0 ];
    var color = options[ 1 ];

    // if( !Chalk.styles[ color ] )
    // color = 'reset';

    if( style === 'foreground')
    {
      if( color !== 'default' )
      {
        self._fgcolor = color;
        result+= Chalk.styles[ color ].open;
      }
      else
      {
        result+= Chalk.styles[ self._fgcolor ].close;
      }
      ++i;
    }
    else if( style === 'background' )
    {
      if( color !== 'default' )
      {
        self._bgcolor = color;
        color = 'bg' + _.strCapitalize( color );
        result+= Chalk.styles[ color ].open;
      }
      else
      {
        color = 'bg' + _.strCapitalize( self._bgcolor );
        result+= Chalk.styles[ color ].close;
      }
      ++i;
    }
    else
    {
      result += str[ i ];
      ++i;
    }

  }
  return result;
}

//

var writeDoing = function( args )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var optionsForStr =
  {
    linePrefix : self._prefix,
    linePostfix : self._postfix,
  }

  var result = _.strConcat.apply( optionsForStr,args );

  if( !isBrowser )
  result = self._writeDoingChalk( result );
  else
  result = self._writeDoing( result );

  return result;
}

//

var symbolForLevel = Symbol.for( 'level' );
var levelSet = function( level )
{
  var self = this;

  _.assert( _.isFinite( level ) );

  Parent.prototype.levelSet.call( self,level );

  var level = self[ symbolForLevel ];

  self._prefix = _.strTimes( self._dprefix,level );
  self._postfix = _.strTimes( self._dpostfix,level );

  // self.format.level = level;
  // self.format.prefix.current = _.strTimes( self.format.prefix.up,level );
  // self.format.postfix.current = _.strTimes( self.format.postfix.up,level );

}

//

var topic = ( function()
{

  // var Chalk;

  return function topic()
  {
    var self = this;

    debugger;
    //throw _.err( 'not tested' );

    var s = _.str.apply( _,arguments );

    if( Chalk === undefined && typeof module !== 'undefined' )
    try
    {
      Chalk = require( 'chalk' );
    }
    catch( err ) 
    {
      Chalk = null;
    }

    if( Chalk )
    s = Chalk.bgWhite( Chalk.black( s ) );

    this.log();
    this.log( s );
    this.log();

    return s;
  }

})();

// --
// var
// --

// var format =
// {
//   level : 0,
//   prefix :
//   {
//     current : '',
//     up : '  ',
//     down : [ 2,0 ]
//   },
//   postfix :
//   {
//     current : '',
//     up : '',
//     down : ''
//   }
// }

// --
// relationships
// --

var Composes =
{

  _prefix : '',
  _postfix : '',

  _dprefix : '  ',
  _dpostfix : '',

  _fgcolor : null,
  _bgcolor : null

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

  writeDoing : writeDoing,
  _writeDoingChalk : _writeDoingChalk,

  levelSet : levelSet,

  topic : topic,

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

//

_.accessor
({
  object : Self.prototype,
  rewriting : 1,
  names :
  {
    level : 'level',
  }
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools.PrinterMid = Self;

return Self;

})();
