using Toybox.Lang;
using Toybox.Math;
using Toybox.Time;
using Toybox.System;

module Util {

	(:Array)
	module Array {
		
		// Array.map - accepts either Array or dictionary	
		function map(arr, func){
			var ret, idx;
			/*
			if (((arr instanceof Lang.Array) == false) && ((arr instanceof Lang.Array) == false)) {
				throw new Lang.UnexpectedTypeException();			
			} */
			
			if (arr instanceof Lang.Array){
				ret = [];
				for (var i = 0; i < arr.size(); i++){
					var val = func.invoke(arr[i]);
					ret.add(val);
				}
				
				
			}
			else if (arr instanceof Lang.Dictionary){
				ret = {};
				for (var i = 0; i < arr.keys().size(); i++){
					var val = func.invoke(arr[arr.keys()[i]]);
					ret.put(arr.keys()[i], val);
				}		
			} else {
				ret = null; //	throw new Lang.UnexpectedTypeException("a", "b");
			}
				
			return ret;
		}

		
		
		function defaultCompare(a, b){
			return (a < b)?true:false;
		}
		
		function sort( array, cmp ){
			var length = array.size();
			var mid = Math.floor(length/2);
			var left = array.slice(0,mid);
			var right = array.slice(mid,length);
			if (length == 1){
			 	return array;
			}
			return merge( sort(left, cmp), sort(right, cmp), cmp );
		}
		
	
		
		
	    function merge(left, right, comparator){
			var result = [];
			
			var cmp = comparator?comparator:(new Toybox.Lang.Method(Util.Array, :defaultCompare));
			
			var i = 0;
			var j = 0;
			var lsize = left.size();
			var rsize = right.size();
		
			
			while ((lsize > i) || (rsize > j )) {
				if ((lsize > i) && (rsize > j )){
					if ( cmp.invoke(left[i], right[j]) ) {
						result.add( left[i] );
						i++;
					} else {
						result.add( right[j] );
						j++;
					}
				} else if (lsize > i) {
					result.add( left[i] );
					i++;					
				} else {
					result.add( right[j] );
					j++;
				}
				
			} 
			return result;
		}

	}
	
	(:Datetime)
	module Datetime	{
	    function parseISODate(date) {
        // assert(date instanceOf String)
        // 0123456789012345678901234
        // 2011-10-17T13:00:00-07:00
        // 2011-10-17T16:30:55.000Z
        // 2011-10-17T16:30:55Z
        if (date.length() < 20) {
            return null;
        }

        var moment = Time.Gregorian.moment({
            :year   => date.substring( 0,  4).toNumber(),
            :month  => date.substring( 5,  7).toNumber(),
            :day    => date.substring( 8, 10).toNumber(),
            :hour   => date.substring(11, 13).toNumber(),
            :minute => date.substring(14, 16).toNumber(),
            :second => date.substring(17, 19).toNumber() 
        });
        var suffix = date.substring(19, date.length());

        // skip over to time zone
        var tz = 0;
        if (suffix.substring(tz, tz + 1).equals(".")) {
            while (tz < suffix.length()) {
                var first = suffix.substring(tz, tz + 1);
                if ("-+Z".find(first) != null) {
                    break;
                }
                tz++;
            }
        }

        if (tz >= suffix.length()) {
            // no timezone given
            return null;
        }
        var tzOffset = 0;
        if (!suffix.substring(tz, tz + 1).equals("Z")) {
            // +HH:MM
            if (suffix.length() - tz >= 6) {
	            tzOffset  = suffix.substring(tz + 1, tz + 3).toNumber() * Time.Gregorian.SECONDS_PER_HOUR;
	            tzOffset += suffix.substring(tz + 4, tz + 6).toNumber() * Time.Gregorian.SECONDS_PER_MINUTE;
            }
            if (suffix.length() - tz == 5) {
	            tzOffset  = suffix.substring(tz + 1, tz + 3).toNumber() * Time.Gregorian.SECONDS_PER_HOUR;
	            tzOffset += suffix.substring(tz + 3, tz + 5).toNumber() * Time.Gregorian.SECONDS_PER_MINUTE;
            }

            var sign = suffix.substring(tz, tz + 1);
            if (sign.equals("+")) {
                tzOffset = -tzOffset;
            } else if (sign.equals("-") && tzOffset == 0) {
                // -00:00 denotes unknown timezone
                return null;
            }
        }
        return moment.add(new Time.Duration(tzOffset));
    }
	
	}


	(:Location)
	module Location {
	
		const WGS84_a = 6378137.0;
		const WGS84_b = 6356752.3;
		
		
		function getBBoxFromRadius(lat, long, radius){
		
		}
	
		function getDistance( locA, locB){
		
		}
	
		function rad2deg(rad){

		}
		
		function deg2rad(deg){
		
		}
	
	}

}
