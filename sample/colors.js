require( 'wTools' );
require( '../staging/abase/printer/printer/Logger.s' );

var _ = wTools;

var colorNames = _.mapOwnKeys( _.color.ColorMapShell );
var n = 0;
// var list = [];
var c = 0;
var line = '';
for( var i = 0; i < colorNames.length; i++ )
{
  var fg = colorNames[ i ];

  for( var j = colorNames.length - 1; j >= 0; --j )
  {
    var bg = colorNames[ j ];
    n++;
    var text = '  #' + n + '  ';
    // list.push( [ '#' + n + ' ' + fg + ' - ' + bg ] )

    if( n <= 10 )
    text += '  ';
    else if( n <= 100 )
    text += ' ';

    line += _.strColor.bg( _.strColor.fg( text, fg ), bg );
    c++;
    if( c === 8 )
    {
      logger.log( line );
      c = 0;
      line = '';
    }
  }
}

/* List :

Number  foreground - backround

#1 white - light white            #2 white - light green           #3 white - light cyan
#4 white - light blue             #5 white - light magenta         #6 white - light red
#7 white - light yellow           #8 white - light black           #9 white - magenta
#10 white - cyan                  #11 white - blue                 #12 white - yellow
#13 white - red                   #14 white - green                #15 white - black
#16 white - white                 #17 black - light white          #18 black - light green
#19 black - light cyan            #20 black - light blue           #21 black - light magenta
#22 black - light red             #23 black - light yellow         #24 black - light black
#25 black - magenta               #26 black - cyan                 #27 black - blue
#28 black - yellow                #29 black - red                  #30 black - green
#31 black - black                 #32 black - white                #33 green - light white
#34 green - light green           #35 green - light cyan           #36 green - light blue
#37 green - light magenta         #38 green - light red            #39 green - light yellow
#40 green - light black           #41 green - magenta              #42 green - cyan
#43 green - blue                  #44 green - yellow               #45 green - red
#46 green - green                 #47 green - black                #48 green - white
#49 red - light white             #50 red - light green            #51 red - light cyan
#52 red - light blue              #53 red - light magenta          #54 red - light red
#55 red - light yellow            #56 red - light black            #57 red - magenta
#58 red - cyan                    #59 red - blue                   #60 red - yellow
#61 red - red                     #62 red - green                  #63 red - black
#64 red - white                   #65 yellow - light white         #66 yellow - light green
#67 yellow - light cyan           #68 yellow - light blue          #69 yellow - light magenta
#70 yellow - light red            #71 yellow - light yellow        #72 yellow - light black
#73 yellow - magenta              #74 yellow - cyan                #75 yellow - blue
#76 yellow - yellow               #77 yellow - red                 #78 yellow - green
#79 yellow - black                #80 yellow - white               #81 blue - light white
#82 blue - light green            #83 blue - light cyan            #84 blue - light blue
#85 blue - light magenta          #86 blue - light red             #87 blue - light yellow
#88 blue - light black            #89 blue - magenta               #90 blue - cyan
#91 blue - blue                   #92 blue - yellow                #93 blue - red
#94 blue - green                  #95 blue - black                 #96 blue - white
#97 cyan - light white            #98 cyan - light green           #99 cyan - light cyan
#100 cyan - light blue            #101 cyan - light magenta        #102 cyan - light red
#103 cyan - light yellow          #104 cyan - light black          #105 cyan - magenta
#106 cyan - cyan                  #107 cyan - blue                 #108 cyan - yellow
#109 cyan - red                   #110 cyan - green                #111 cyan - black
#112 cyan - white                 #113 magenta - light white       #114 magenta - light green
#115 magenta - light cyan         #116 magenta - light blue        #117 magenta - light magenta
#118 magenta - light red          #119 magenta - light yellow      #120 magenta - light black
#121 magenta - magenta            #122 magenta - cyan              #123 magenta - blue
#124 magenta - yellow             #125 magenta - red               #126 magenta - green
#127 magenta - black              #128 magenta - white             #129 light black - light white
#130 light black - light green    #131 light black - light cyan    #132 light black - light blue
#133 light black - light magenta  #134 light black - light red     #135 light black - light yellow
#136 light black - light black    #137 light black - magenta       #138 light black - cyan
#139 light black - blue           #140 light black - yellow        #141 light black - red
#142 light black - green          #143 light black - black         #144 light black - white
#145 light yellow - light white   #146 light yellow - light green  #147 light yellow - light cyan
#148 light yellow - light blue    #149 light yellow - light magenta#150 light yellow - light red
#151 light yellow - light yellow  #152 light yellow - light black  #153 light yellow - magenta
#154 light yellow - cyan          #155 light yellow - blue         #156 light yellow - yellow
#157 light yellow - red           #158 light yellow - green        #159 light yellow - black
#160 light yellow - white         #161 light red - light white     #162 light red - light green
#163 light red - light cyan       #164 light red - light blue      #165 light red - light magenta
#166 light red - light red        #167 light red - light yellow    #168 light red - light black
#169 light red - magenta          #170 light red - cyan            #171 light red - blue
#172 light red - yellow           #173 light red - red             #174 light red - green
#175 light red - black            #176 light red - white           #177 light magenta - light white
#178 light magenta - light green  #179 light magenta - light cyan  #180 light magenta - light blue
#181 light magenta - light magenta#182 light magenta - light red   #183 light magenta - light yellow
#184 light magenta - light black  #185 light magenta - magenta     #186 light magenta - cyan
#187 light magenta - blue         #188 light magenta - yellow      #189 light magenta - red
#190 light magenta - green        #191 light magenta - black       #192 light magenta - white
#193 light blue - light white     #194 light blue - light green    #195 light blue - light cyan
#196 light blue - light blue      #197 light blue - light magenta  #198 light blue - light red
#199 light blue - light yellow    #200 light blue - light black    #201 light blue - magenta
#202 light blue - cyan            #203 light blue - blue           #204 light blue - yellow
#205 light blue - red             #206 light blue - green          #207 light blue - black
#208 light blue - white           #209 light cyan - light white    #210 light cyan - light green
#211 light cyan - light cyan      #212 light cyan - light blue     #213 light cyan - light magenta
#214 light cyan - light red       #215 light cyan - light yellow   #216 light cyan - light black
#217 light cyan - magenta         #218 light cyan - cyan           #219 light cyan - blue
#220 light cyan - yellow          #221 light cyan - red            #222 light cyan - green
#223 light cyan - black           #224 light cyan - white          #225 light green - light white
#226 light green - light green    #227 light green - light cyan    #228 light green - light blue
#229 light green - light magenta  #230 light green - light red     #231 light green - light yellow
#232 light green - light black    #233 light green - magenta       #234 light green - cyan
#235 light green - blue           #236 light green - yellow        #237 light green - red
#238 light green - green          #239 light green - black         #240 light green - white
#241 light white - light white    #242 light white - light green   #243 light white - light cyan
#244 light white - light blue     #245 light white - light magenta #246 light white - light red
#247 light white - light yellow   #248 light white - light black   #249 light white - magenta
#250 light white - cyan           #251 light white - blue          #252 light white - yellow
#253 light white - red            #254 light white - green         #255 light white - black
#256 light white - white
*/
