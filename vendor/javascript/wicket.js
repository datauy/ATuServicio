// wicket@1.3.8 downloaded from https://ga.jspm.io/npm:wicket@1.3.8/wicket.js

var t="undefined"!==typeof globalThis?globalThis:"undefined"!==typeof self?self:global;var e={};
/** @license
 *
 *  Copyright (C) 2012 K. Arthur Endsley (kaendsle@mtu.edu)
 *  Michigan Tech Research Institute (MTRI)
 *  3600 Green Court, Suite 100, Ann Arbor, MI, 48105
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */(function(t,s){e=s()})(0,(function(){var e,s,i;this||t;i=function(e){if(e instanceof i)return e;if(!((this||t)instanceof i))return new i(e);(this||t)._wrapped=e};
/**
   * Returns true if the substring is found at the beginning of the string.
   * @param   str {String}    The String to search
   * @param   sub {String}    The substring of interest
   * @return      {Boolean}
   * @private
   */e=function(t,e){return t.substring(0,e.length)===e};
/**
   * Returns true if the substring is found at the end of the string.
   * @param   str {String}    The String to search
   * @param   sub {String}    The substring of interest
   * @return      {Boolean}
   * @private
   */s=function(t,e){return t.substring(t.length-e.length)===e};i.delimiter=" ";
/**
   * Determines whether or not the passed Object is an Array.
   * @param   obj {Object}    The Object in question
   * @return      {Boolean}
   * @member Wkt.isArray
   * @method
   */i.isArray=function(t){return!!(t&&t.constructor===Array)};
/**
   * Removes given character String(s) from a String.
   * @param   str {String}    The String to search
   * @param   sub {String}    The String character(s) to trim
   * @return      {String}    The trimmed string
   * @member Wkt.trim
   * @method
   */i.trim=function(t,i){i=i||" ";while(e(t,i))t=t.substring(1);while(s(t,i))t=t.substring(0,t.length-1);return t};
/**
   * An object for reading WKT strings and writing geographic features
   * @constructor this.Wkt.Wkt
   * @param   initializer {String}    An optional WKT string for immediate read
   * @property            {Array}     components      - Holder for atomic geometry objects (internal representation of geometric components)
   * @property            {String}    delimiter       - The default delimiter for separating components of atomic geometry (coordinates)
   * @property            {Object}    regExes         - Some regular expressions copied from OpenLayers.Format.WKT.js
   * @property            {String}    type            - The Well-Known Text name (e.g. 'point') of the geometry
   * @property            {Boolean}   wrapVerticies   - True to wrap vertices in MULTIPOINT geometries; If true: MULTIPOINT((30 10),(10 30),(40 40)); If false: MULTIPOINT(30 10,10 30,40 40)
   * @return              {this.Wkt.Wkt}
   * @memberof Wkt
   */i.Wkt=function(e){(this||t).delimiter=i.delimiter||" ";(this||t).wrapVertices=true;(this||t).regExes={typeStr:/^\s*(\w+)\s*\(\s*(.*)\s*\)\s*$/,spaces:/\s+|\+/,numeric:/-*\d+(\.*\d+)?/,comma:/\s*,\s*/,parenComma:/\)\s*,\s*\(/,coord:/-*\d+\.*\d+ -*\d+\.*\d+/,doubleParenComma:/\)\s*\)\s*,\s*\(\s*\(/,ogcTypes:/^(multi)?(point|line|polygon|box)?(string)?$/i,crudeJson:/^{.*"(type|coordinates|geometries|features)":.*}$/};
/**
     * Strip any whitespace and parens from front and back.
     * This is the equivalent of s/^\s*\(?(.*)\)?\s*$/$1/ but without the risk of catastrophic backtracking.
     * @param   str {String}
     */(this||t)._stripWhitespaceAndParens=function(t){var e=t.trim();var s=e.replace(/^\(?(.*?)\)?$/,"$1");return s};(this||t).components=void 0;e&&"string"===typeof e?this.read(e):e&&void 0!==typeof e&&this.fromObject(e)};i.Wkt.prototype.isCollection=function(){switch((this||t).type.slice(0,5)){case"multi":return true;case"polyg":return true;default:return false}};
/**
   * Compares two x,y coordinates for equality.
   * @param   a   {Object}    An object with x and y properties
   * @param   b   {Object}    An object with x and y properties
   * @return      {Boolean}
   * @memberof this.Wkt.Wkt
   * @method
   */i.Wkt.prototype.sameCoords=function(t,e){return t.x===e.x&&t.y===e.y};
/**
   * Sets internal geometry (components) from framework geometry (e.g.
   * Google Polygon objects or google.maps.Polygon).
   * @param   obj {Object}    The framework-dependent geometry representation
   * @return      {this.Wkt.Wkt}   The object itself
   * @memberof this.Wkt.Wkt
   * @method
   */i.Wkt.prototype.fromObject=function(e){var s;s=e.hasOwnProperty("type")&&e.hasOwnProperty("coordinates")?this.fromJson(e):(this||t).deconstruct.call(this||t,e);(this||t).components=s.components;(this||t).isRectangle=s.isRectangle||false;(this||t).type=s.type;return this||t};
/**
   * Creates external geometry objects based on a plug-in framework's
   * construction methods and available geometry classes.
   * @param   config  {Object}    An optional framework-dependent properties specification
   * @return          {Object}    The framework-dependent geometry representation
   * @memberof this.Wkt.Wkt
   * @method
   */i.Wkt.prototype.toObject=function(e){var s=(this||t).construct[(this||t).type].call(this||t,e);"object"!==typeof s||i.isArray(s)||(s.properties=(this||t).properties);return s};i.Wkt.prototype.toString=function(t){return this.write()};
/**
   * Parses a JSON representation as an Object.
   * @param	obj	{Object}	An Object with the GeoJSON schema
   * @return	{this.Wkt.Wkt}	The object itself
   * @memberof this.Wkt.Wkt
   * @method
   */i.Wkt.prototype.fromJson=function(e){var s,r,n,o,p,h;(this||t).type=e.type.toLowerCase();(this||t).components=[];if(e.hasOwnProperty("geometry")){this.fromJson(e.geometry);(this||t).properties=e.properties;return this||t}o=e.coordinates;if(i.isArray(o[0])){for(s in o)if(o.hasOwnProperty(s))if(i.isArray(o[s][0])){h=[];for(r in o[s])if(o[s].hasOwnProperty(r))if(i.isArray(o[s][r][0])){p=[];for(n in o[s][r])o[s][r].hasOwnProperty(n)&&p.push({x:o[s][r][n][0],y:o[s][r][n][1]});h.push(p)}else h.push({x:o[s][r][0],y:o[s][r][1]});(this||t).components.push(h)}else"multipoint"===(this||t).type?(this||t).components.push([{x:o[s][0],y:o[s][1]}]):(this||t).components.push({x:o[s][0],y:o[s][1]})}else(this||t).components.push({x:o[0],y:o[1]});return this||t};i.Wkt.prototype.toJson=function(){var e,s,r,n,o,p,h;e=(this||t).components;s={coordinates:[],type:function(){var e,s,i;s=(this||t).regExes.ogcTypes.exec((this||t).type).slice(1);i=[];for(e in s)s.hasOwnProperty(e)&&void 0!==s[e]&&i.push(s[e].toLowerCase().slice(0,1).toUpperCase()+s[e].toLowerCase().slice(1));return i}.call(this||t).join("")};if("box"===(this||t).type.toLowerCase()){s.type="Polygon";s.bbox=[];for(r in e)e.hasOwnProperty(r)&&(s.bbox=s.bbox.concat([e[r].x,e[r].y]));s.coordinates=[[[e[0].x,e[0].y],[e[0].x,e[1].y],[e[1].x,e[1].y],[e[1].x,e[0].y],[e[0].x,e[0].y]]];return s}for(r in e)if(e.hasOwnProperty(r))if(i.isArray(e[r])){h=[];for(n in e[r])if(e[r].hasOwnProperty(n))if(i.isArray(e[r][n])){p=[];for(o in e[r][n])e[r][n].hasOwnProperty(o)&&p.push([e[r][n][o].x,e[r][n][o].y]);h.push(p)}else e[r].length>1?h.push([e[r][n].x,e[r][n].y]):h=h.concat([e[r][n].x,e[r][n].y]);s.coordinates.push(h)}else e.length>1?s.coordinates.push([e[r].x,e[r].y]):s.coordinates=s.coordinates.concat([e[r].x,e[r].y]);return s};
/**
   * Absorbs the geometry of another this.Wkt.Wkt instance, merging it with its own,
   * creating a collection (MULTI-geometry) based on their types, which must agree.
   * For example, creates a MULTIPOLYGON from a POLYGON type merged with another
   * POLYGON type, or adds a POLYGON instance to a MULTIPOLYGON instance.
   * @param   wkt {String}    A Wkt.Wkt object
   * @return	{this.Wkt.Wkt}	The object itself
   * @memberof this.Wkt.Wkt
   * @method
   */i.Wkt.prototype.merge=function(e){var s=(this||t).type.slice(0,5);if((this||t).type!==e.type&&(this||t).type.slice(5,(this||t).type.length)!==e.type)throw TypeError("The input geometry types must agree or the calling this.Wkt.Wkt instance must be a multigeometry of the other");switch(s){case"point":(this||t).components=[(this||t).components.concat(e.components)];break;case"multi":(this||t).components=(this||t).components.concat("multi"===e.type.slice(0,5)?e.components:[e.components]);break;default:(this||t).components=[(this||t).components,e.components];break}"multi"!==s&&((this||t).type="multi"+(this||t).type);return this||t};
/**
   * Reads a WKT string, validating and incorporating it.
   * @param   str {String}    A WKT or GeoJSON string
   * @return	{this.Wkt.Wkt}	The object itself
   * @memberof this.Wkt.Wkt
   * @method
   */i.Wkt.prototype.read=function(e){var s;s=(this||t).regExes.typeStr.exec(e);if(s){(this||t).type=s[1].toLowerCase();(this||t).base=s[2];(this||t).ingest[(this||t).type]&&((this||t).components=(this||t).ingest[(this||t).type].apply(this||t,[(this||t).base]))}else{if(!(this||t).regExes.crudeJson.test(e)){console.log("Invalid WKT string provided to read()");throw{name:"WKTError",message:"Invalid WKT string provided to read()"}}if("object"!==typeof JSON||"function"!==typeof JSON.parse){console.log("JSON.parse() is not available; cannot parse GeoJSON strings");throw{name:"JSONError",message:"JSON.parse() is not available; cannot parse GeoJSON strings"}}this.fromJson(JSON.parse(e))}return this||t};
/**
   * Writes a WKT string.
   * @param   components  {Array}     An Array of internal geometry objects
   * @return              {String}    The corresponding WKT representation
   * @memberof this.Wkt.Wkt
   * @method
   */i.Wkt.prototype.write=function(e){var s,i,r;e=e||(this||t).components;i=[];i.push((this||t).type.toUpperCase()+"(");for(s=0;s<e.length;s+=1){this.isCollection()&&s>0&&i.push(",");if(!(this||t).extract[(this||t).type])return null;r=(this||t).extract[(this||t).type].apply(this||t,[e[s]]);if(this.isCollection()&&"multipoint"!==(this||t).type)i.push("("+r+")");else{i.push(r);s!==e.length-1&&"multipoint"!==(this||t).type&&i.push(",")}}i.push(")");return i.join("")};i.Wkt.prototype.extract={
/**
     * Return a WKT string representing atomic (point) geometry
     * @param   point   {Object}    An object with x and y properties
     * @return          {String}    The WKT representation
     * @memberof this.Wkt.Wkt.extract
     * @instance
     */
point:function(e){return String(e.x)+(this||t).delimiter+String(e.y)},
/**
     * Return a WKT string representing multiple atoms (points)
     * @param   multipoint  {Array}     Multiple x-and-y objects
     * @return              {String}    The WKT representation
     * @memberof this.Wkt.Wkt.extract
     * @instance
     */
multipoint:function(e){var s,i,r=[];for(s=0;s<e.length;s+=1){i=(this||t).extract.point.apply(this||t,[e[s]]);(this||t).wrapVertices&&(i="("+i+")");r.push(i)}return r.join(",")},
/**
     * Return a WKT string representing a chain (linestring) of atoms
     * @param   linestring  {Array}     Multiple x-and-y objects
     * @return              {String}    The WKT representation
     * @memberof this.Wkt.Wkt.extract
     * @instance
     */
linestring:function(e){return(this||t).extract.point.apply(this||t,[e])},
/**
     * Return a WKT string representing multiple chains (multilinestring) of atoms
     * @param   multilinestring {Array}     Multiple of multiple x-and-y objects
     * @return                  {String}    The WKT representation
     * @memberof this.Wkt.Wkt.extract
     * @instance
     */
multilinestring:function(e){var s,i=[];if(e.length)for(s=0;s<e.length;s+=1)i.push((this||t).extract.linestring.apply(this||t,[e[s]]));else i.push((this||t).extract.point.apply(this||t,[e]));return i.join(",")},
/**
     * Return a WKT string representing multiple atoms in closed series (polygon)
     * @param   polygon {Array}     Collection of ordered x-and-y objects
     * @return          {String}    The WKT representation
     * @memberof this.Wkt.Wkt.extract
     * @instance
     */
polygon:function(e){return(this||t).extract.multilinestring.apply(this||t,[e])},
/**
     * Return a WKT string representing multiple closed series (multipolygons) of multiple atoms
     * @param   multipolygon    {Array}     Collection of ordered x-and-y objects
     * @return                  {String}    The WKT representation
     * @memberof this.Wkt.Wkt.extract
     * @instance
     */
multipolygon:function(e){var s,i=[];for(s=0;s<e.length;s+=1)i.push("("+(this||t).extract.polygon.apply(this||t,[e[s]])+")");return i.join(",")},
/**
     * Return a WKT string representing a 2DBox
     * @param   multipolygon    {Array}     Collection of ordered x-and-y objects
     * @return                  {String}    The WKT representation
     * @memberof this.Wkt.Wkt.extract
     * @instance
     */
box:function(e){return(this||t).extract.linestring.apply(this||t,[e])},geometrycollection:function(t){console.log("The geometrycollection WKT type is not yet supported.")}};i.Wkt.prototype.ingest={
/**
     * Return point feature given a point WKT fragment.
     * @param   str {String}    A WKT fragment representing the point
     * @memberof this.Wkt.Wkt.ingest
     * @instance
     */
point:function(e){var s=i.trim(e).split((this||t).regExes.spaces);return[{x:parseFloat((this||t).regExes.numeric.exec(s[0])[0]),y:parseFloat((this||t).regExes.numeric.exec(s[1])[0])}]},
/**
     * Return a multipoint feature given a multipoint WKT fragment.
     * @param   str {String}    A WKT fragment representing the multipoint
     * @memberof this.Wkt.Wkt.ingest
     * @instance
     */
multipoint:function(e){var s,r,n;r=[];n=i.trim(e).split((this||t).regExes.comma);for(s=0;s<n.length;s+=1)r.push((this||t).ingest.point.apply(this||t,[n[s]]));return r},
/**
     * Return a linestring feature given a linestring WKT fragment.
     * @param   str {String}    A WKT fragment representing the linestring
     * @memberof this.Wkt.Wkt.ingest
     * @instance
     */
linestring:function(e){var s,i,r;i=(this||t).ingest.multipoint.apply(this||t,[e]);r=[];for(s=0;s<i.length;s+=1)r=r.concat(i[s]);return r},
/**
     * Return a multilinestring feature given a multilinestring WKT fragment.
     * @param   str {String}    A WKT fragment representing the multilinestring
     * @memberof this.Wkt.Wkt.ingest
     * @instance
     */
multilinestring:function(e){var s,r,n,o;r=[];o=i.trim(e).split((this||t).regExes.doubleParenComma);1===o.length&&(o=i.trim(e).split((this||t).regExes.parenComma));for(s=0;s<o.length;s+=1){n=this._stripWhitespaceAndParens(o[s]);r.push((this||t).ingest.linestring.apply(this||t,[n]))}return r},
/**
     * Return a polygon feature given a polygon WKT fragment.
     * @param   str {String}    A WKT fragment representing the polygon
     * @memberof this.Wkt.Wkt.ingest
     * @instance
     */
polygon:function(e){var s,r,n,o,p,h;h=i.trim(e).split((this||t).regExes.parenComma);n=[];for(s=0;s<h.length;s+=1){p=this._stripWhitespaceAndParens(h[s]).split((this||t).regExes.comma);o=[];for(r=0;r<p.length;r+=1){var a=p[r].split((this||t).regExes.spaces);a.length>2&&(a=a.filter((function(t){return""!=t})));if(2===a.length){var c=a[0];var l=a[1];o.push({x:parseFloat(c),y:parseFloat(l)})}}n.push(o)}return n},
/**
     * Return box vertices (which would become the Rectangle bounds) given a Box WKT fragment.
     * @param   str {String}    A WKT fragment representing the box
     * @memberof this.Wkt.Wkt.ingest
     * @instance
     */
box:function(e){var s,i,r;i=(this||t).ingest.multipoint.apply(this||t,[e]);r=[];for(s=0;s<i.length;s+=1)r=r.concat(i[s]);return r},
/**
     * Return a multipolygon feature given a multipolygon WKT fragment.
     * @param   str {String}    A WKT fragment representing the multipolygon
     * @memberof this.Wkt.Wkt.ingest
     * @instance
     */
multipolygon:function(e){var s,r,n,o;r=[];o=i.trim(e).split((this||t).regExes.doubleParenComma);for(s=0;s<o.length;s+=1){n=this._stripWhitespaceAndParens(o[s]);r.push((this||t).ingest.polygon.apply(this||t,[n]))}return r},
/**
     * Return an array of features given a geometrycollection WKT fragment.
     * @param   str {String}    A WKT fragment representing the geometry collection
     * @memberof this.Wkt.Wkt.ingest
     * @instance
     */
geometrycollection:function(t){console.log("The geometrycollection WKT type is not yet supported.")}};return i}));var s=e;export{s as default};

