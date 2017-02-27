(function _aColoredMixin_s_() {

'use strict';

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

  var _ = wTools;

  try
  {
    _.include( 'wColor' );
  }
  catch( err )
  {
  }

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

  _.accessor
  ({
    object : dst,
    combining : 'rewrite',
    names :
    {
      // level : 'level',
      foregroundColor : 'foregroundColor',
      backgroundColor : 'backgroundColor',
    }
  });

}

//

function _rgbToCode( rgb )
{
  var r = rgb[ 0 ];
  var g = rgb[ 1 ];
  var b = rgb[ 2 ];

  var ansi = 30 + ( ( Math.round( b ) << 2 ) | (Math.round( g ) << 1 ) | Math.round( r ) );

  return ansi;
}

//

function _onStrip( strip )
{
  var allowedKeys = [ 'bg','background','fg','foreground' ];
  var parts = strip.split( ' : ' )
  if( parts.length === 2 )
  {
    if( allowedKeys.indexOf( parts[ 0 ] ) === -1 )
    return;
    return parts;
  }
}

//

function _colorConvert( color )
{
  if( !color )
  return null;

  try
  {
    if( !isBrowser )
    color = _.color.rgbFrom( color );
    else
    color = _.color.rgbaFrom( color );
  }
  catch ( err )
  {
    var name = _.color.colorNameNearest( color );
    if( name )
    color = _.color.ColorMap[ name ];
    else
    return null;
  }

  return color;
}

//

function _foregroundColorGet()
{
  var self = this;
  return self[ symbolForForeground ];
}

//

function _backgroundColorGet()
{
  var self = this;
  return self[ symbolForBackground ];
}

//

function _foregroundColorSet( color )
{
  var self = this;
  var style = 'foreground';

  if( !color || color === 'default' )
  {
    if( self._stackIsNotEmpty( style ) )
    self[ symbolForForeground ] = self._stackPop( style );
    else
    self[ symbolForForeground ] = null;
  }
  else
  {
    if( self[ symbolForForeground ] )
    self._stackPush( style, self[ symbolForForeground ] );

    self[ symbolForForeground ] = self._colorConvert( color );
  }
}

//

function _backgroundColorSet( color )
{
  var self = this;
  var style = 'background';

  if( !color || color === 'default' )
  {
    if( self._stackIsNotEmpty( style ) )
    self[ symbolForBackground ] = self._stackPop( style );
    else
    self[ symbolForBackground ] = null;
  }
  else
  {
    if( self[ symbolForBackground ] )
    self._stackPush( style, self[ symbolForBackground ] );

    self[ symbolForBackground ] = self._colorConvert( color );
  }
}

//

function _stackPush( style, color )
{
  var self = this;

  if( !self.colorsStack )
  {
    self.colorsStack = { 'foreground' : [], 'background' : [] };
  }

  self.colorsStack[ style ].push( color );
}

//

function _stackPop( style )
{
  var self = this;

  return self.colorsStack[ style ].pop();
}

//

function _stackIsNotEmpty( style )
{
  var self = this;
  if( self.colorsStack && self.colorsStack[ style ].length )
  return true;

  return false;
}

//

function _writeBeginBrowser( str )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( str ) );

  var result = [ '' ];

  var splitted = _.strExtractStrips( str, { onStrip : self._onStrip } );
  if( splitted.length === 1 && !self._isStyled )
  {
    if( !_.arrayIs( splitted[ 0 ] ) )
    return splitted;
  }

  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      var style = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( style === 'foreground')
      {
        self.foregroundColor = color;
      }
      else if( style === 'background')
      {
        self.backgroundColor = color;
      }
      if( !self.foregroundColor && !self.backgroundColor )
      self._isStyled = 0;
      else if( !!self.foregroundColor | !!self.backgroundColor )
      self._isStyled = 1;
    }
    else
    {
      if( !i && !self._isStyled )
      {
        result[ 0 ] += splitted[ i ];
      }
      else
      {
        var fg = self.foregroundColor || 'none';
        var bg = self.backgroundColor || 'none';

        result[ 0 ] += `%c${ splitted[ i ] }`;
        result.push( `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };` );
      }
    }
  }

  if( !result[ 0 ].length )
  return [];
  return result;
}

//

function _writeBeginShell( str )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( str ) );

  var result = '';

  var splitted = _.strExtractStrips( str, { onStrip : self._onStrip } );
  var stylesOnly = true;
  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.strIs( splitted[ i ] ) )
    {
      stylesOnly = false;

      if( self._cursorSaved )
      {
        /*restores cursos position*/
        result +=  '\x1b[u';
        self._cursorSaved = 0;
      }
      result +=  splitted[ i ];
    }
    else
    {
      var style = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( style === 'foreground')
      {
        self.foregroundColor = color;

        if( self.foregroundColor )
        result += `\x1b[${ self._rgbToCode( self.foregroundColor ) }m`;
        else
        result += `\x1b[39m`;
      }
      else if( style === 'background' )
      {
        self.backgroundColor = color;

        if( self.backgroundColor )
        result += `\x1b[${ self._rgbToCode( self.backgroundColor ) + 10 }m`;
        else
        result += `\x1b[49m`;
      }
    }
  }

  if( stylesOnly )
  { /*saves cursos position*/
    self._cursorSaved = 1;
    result += '\x1b[s';
  }

  return [ result ];
}

//

function _writeWithoutColors( str )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( str ) );

  var result = '';

  var splitted = _.strExtractStrips( str, { onStrip : self._onStrip } );
  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.strIs( splitted[ i ] ) )
    {
      result += splitted[ i ];
    }
  }

  return [ result ];
}

//

function _writeBegin( original )
{

  return function _writeBegin( args )
  {
    var self = this;

    _.assert( arguments.length === 1 );

    var result = original.call( self,args );

    _.assert( _.arrayIs( result ) );
    _.assert( result.length === 1 )

    if( _.color && self.coloring )
    {

      if( self.coloringHeadAndTail )
      {
        if( self.tags.head )
        result[ 0 ] = _.strColor.style( result[ 0 ],'head' )
        else if( self.tags.tail )
        result[ 0 ] = _.strColor.style( result[ 0 ],'tail' )
      }

      if( !isBrowser )
      result = self._writeBeginShell( result[ 0 ] );
      else
      result = self._writeBeginBrowser( result[ 0 ] );

    }
    else
    result = self._writeWithoutColors( result[ 0 ] );

    _.assert( _.arrayIs( result ) );

    return result;
  }

}

//

function topic()
{
  var self = this;

  debugger;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  result = _.strColor.bg( result,'white' );

  this.log();
  this.log( result );
  this.log();

  return result;
}

//

function topicUp()
{
  var self = this;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  result = _.strColor.bg( result,'white' );

  this.log();
  this.logUp( result );
  this.log();

  return result;
}

//

function topicDown()
{
  var self = this;

  // var result = self._strConcat( arguments );
  var result = _.strConcat.apply( undefined,arguments );

  result = _.strColor.bg( result,'white' );


  this.log();
  this.logDown( result );
  this.log();

  return result;
}


// --
// relationships
// --

var symbolForLevel = Symbol.for( 'level' );
var symbolForForeground = Symbol.for( 'foregroundColor' );
var symbolForBackground = Symbol.for( 'backgroundColor' );

var Composes =
{

  foregroundColor : null,
  backgroundColor : null,

  colorsStack : null,
  coloring : 1,
  coloringHeadAndTail : 1,

  _isStyled : 0,
  _cursorSaved : 0,

  // tags : {},

}

var Aggregates =
{
}

var Associates =
{
}

// --
// proto
// --

var Functor =
{

  _writeBegin : _writeBegin,

}

var Extend =
{

  _foregroundColorGet : _foregroundColorGet,
  _backgroundColorGet : _backgroundColorGet,

  _foregroundColorSet : _foregroundColorSet,
  _backgroundColorSet : _backgroundColorSet,

  _rgbToCode : _rgbToCode,
  _colorConvert : _colorConvert,
  _onStrip : _onStrip,

  _stackPush : _stackPush,
  _stackPop : _stackPop,
  _stackIsNotEmpty : _stackIsNotEmpty,

  _writeBeginShell : _writeBeginShell,
  _writeBeginBrowser : _writeBeginBrowser,
  _writeWithoutColors : _writeWithoutColors,

  topic : topic,
  topicUp : topicUp,
  topicDown : topicDown,


  // relationships

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

var Self =
{

  Extend : Extend,
  Functor : Functor,

  mixin : mixin,

  name : 'wPrinterColoredMixin',
  nameShort : 'PrinterColoredMixin',

}

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
