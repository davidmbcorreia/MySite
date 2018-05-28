
function StellaxiusUtil() {
	j$ = jQuery.noConflict();

	window['stellaxiusUtil'] = this;

	this.selectorDefinitionMap = { };

	this.tooltipClass = "definition-tooltip";

	this.putDefinition = function putDefinition(definitionMap, word, definition) {
		definitionMap[word] = definition;
	}

	this.getDefinition = function getDefinition(definitionMap, word) {
		return definitionMap[word];
	}

	/*
		Wall of Words that shows a tooltip with a word definition
		when mouse hovers each word.

	*/
	this.buildDefinitionWall = function(definitionMap, selector) {
		j$(selector).bind(
			{
				mousemove: 		stellaxiusUtil.changeDefinitionPosition,				
				mouseenter: 	function(event) { stellaxiusUtil.showDefinition(definitionMap, event); },
				mouseleave: 	stellaxiusUtil.hideDefinition
			}
		);
	}

	/*
		Wall of Words that highlights in a different color
		the first letter of each word.

	*/
	this.buildValueWall = function(selector) {
		var standoutValues = j$('span.standout');
		
		j$.each(
			standoutValues,
			function() {
				var words = j$(this).text().split(' ');
				var html = '';

				j$.each(
					words,
					function() {
						html += '<span class="our-values-keyword">' + this.substring(0, 1) + '</span>' + this.substring(1) + ' ';
					}
				);

				j$(this).html(html);
			}
		);
	}

	this.changeDefinitionPosition = function(event) {
		var posX = event.pageX - 8;
		var posY = event.pageY + 8;

		//alert('posX: ' + posX + ', posY: ' + posY);

		var windowWidth = j$(window).width();

		if (posX > (windowWidth * 0.50)) {
			posX = posX - (windowWidth * 0.40);
		}

		j$('div.' + stellaxiusUtil.tooltipClass).css(
			{
				top: 	posY,
				left: 	posX
			}
		);
	}
	
	this.showDefinition = function(definitionMap, event) {
		var stellaxiusUtil = window['stellaxiusUtil'];

		var word = j$(event.currentTarget).text().trim();
		var definition = '';

		if (stellaxiusUtil.getDefinition(definitionMap, word) != null) {
			definition = stellaxiusUtil.getDefinition(definitionMap, word);
		}

		j$('div.' + stellaxiusUtil.tooltipClass).remove();
		j$('<div style="display: none;" class="' + stellaxiusUtil.tooltipClass + '">' + definition + '</div>').appendTo('body').toggle("linear");

		stellaxiusUtil.changeDefinitionPosition(event);
	}

	this.hideDefinition = function() {
		//j$('div.' + stellaxiusUtil.tooltipClass).remove();
		j$('div.' + stellaxiusUtil.tooltipClass).toggle("linear");
	}

	return this;
}
