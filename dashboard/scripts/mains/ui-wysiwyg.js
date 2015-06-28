function htmlEncode(str) {

	// Clean Docs
	str = cleanDocHtml(str);

	// Convert allow tags
	str = String(str)
		.replace(/(<style.*?\/style>)/ig, '')
		.replace(/(<script.*?\/script>)/ig, '')
		.replace(/(&lt;style.*?\/style&gt;)/ig, '')
		.replace(/(&lt;script.*?\/script&gt;)/ig, '')
		.replace(/<br[^>]*>/ig,'[br]')
		.replace(/<div[^>]*>/ig,'[br]')
		.replace(/<p[^>]*>/ig,'[br]')
		.replace(/<ol[^>]*>/ig,'[ol]')
		.replace(/<\/ol[^>]*>/ig, '[/ol]')
		.replace(/<ul[^>]*>/ig,'[ul]')
		.replace(/<\/ul[^>]*>/ig, '[/ul]')
		.replace(/<li[^>]*>/ig,'[li]')
		.replace(/<\/li[^>]*>/ig, '[/li]')
		.replace(/<b[^>]*>/ig,'[b]')
		.replace(/<\/b[^>]*>/ig, '[/b]')
		.replace(/<strong[^>]*>/ig,'[strong]')
		.replace(/<\/strong[^>]*>/ig, '[/strong]')
		.replace(/<em[^>]*>/ig,'[em]')
		.replace(/<\/em[^>]*>/ig, '[/em]')
		.replace(/<i[^>]*>/ig,'[em]')
		.replace(/<\/i[^>]*>/ig, '[/em]')
		.replace(/"/g, '&quot;')
		.replace(/&amp;/g, '&')
		.replace(/&/g, '&amp;');

	var $t = $('<span>'+str+'</span>');
		$t = $t.text()
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/^[\s\n]*\[br\]\[br\]/, '')
			.replace(/^[\s\n]*\[br\]/, '');

	return $t;
}

function htmlDecode(str) {
	var $t;

	$t = String(str)
		.replace(/&amp;/g, '&')
		.replace(/\[br\]/g, '<br>')
		.replace(/\r\n|\n|\r/gm, '')
		.replace(/\[ol\]/g, '<ol>')
		.replace(/\[\/ol\]/g, '</ol>')
		.replace(/\[ul\]/g, '<ul>')
		.replace(/\[\/ul\]/g, '</ul>')
		.replace(/\[li\]/g, '<li>')
		.replace(/\[\/li\]/g, '</li>')
		.replace(/\[b\]/g, '<b>')
		.replace(/\[\/b\]/g, '</b>')
		.replace(/\[strong\]/g, '<strong>')
		.replace(/\[\/strong\]/g, '</strong>')
		.replace(/\[em\]/g, '<em>')
		.replace(/\[\/em\]/g, '</em>');


	$t.replace(/(<style.*?\/style>)/ig, '')
		.replace(/(<script.*?\/script>)/ig, '')
		.replace(/(&lt;style.*?\/style&gt;)/ig, '')
		.replace(/(&lt;script.*?\/script&gt;)/ig, '')
		.replace(/\n/ig,'')
		.replace(/(\r\n|\n|\r)/gm,"");

	return $t;
}

function strip(html)
{
	 html = String(html)
		.replace(/(<p\/>|<p><\/p>|<br>|<div><br><\/div>)/ig,'&nbsp;')
		.replace(/(<style.*?\/style>)/ig, '')
		.replace(/(<script.*?\/script>)/ig, '')
		.replace(/(&lt;style.*?\/style&gt;)/ig, '')
		.replace(/(&lt;script.*?\/script&gt;)/ig, '')
		.replace(/\[[^\]]+\]/ig,'');

	// Convert special characters
	html = html
		.replace(/&ndash;/gi, '')
		.replace(/&mdash;/gi, '')
		.replace(/&iexcl;/gi, '')
		.replace(/&iquest;/gi, '')
		.replace(/&ldquo;/gi, '')
		.replace(/&rdquo;/gi, '')
		.replace(/&lsquo;/gi, '')
		.replace(/&rsquo;/gi, '')
		.replace(/&laquo;/gi, '')
		.replace(/&raquo;/gi, '')
		.replace(/&cent;/gi, '')
		.replace(/&copy;/gi, '')
		.replace(/&divide;/gi, '')
		.replace(/&micro;/gi, '')
		.replace(/&middot;/gi, '')
		.replace(/&plusmn;/gi, '')
		.replace(/&euro;/gi, '')
		.replace(/&pound;/gi, '')
		.replace(/&reg;/gi, '')
		.replace(/&sect;/gi, '')
		.replace(/&trade;/gi, '')
		.replace(/&yen;/gi, '')
		.replace(/&deg;/gi, '');

	 var tmp = document.createElement("DIV");
	 tmp.innerHTML = html;
	try {
		tmp.textContent.replace(/</g, '&lt;').replace(/>/g, '&gt;')||tmp.innerText.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	}
	catch(e) {
	}
	 return $(tmp).text();
}

// TODO: Create a Word clean up function to call in htmlEncode
// ref: http://www.codinghorror.com/blog/2006/01/cleaning-words-nasty-html.html
function cleanDocHtml(str) {

	// Remove nasty stuff
	str = String(str)
		.replace(/<!--(\w|\W)+?-->/ig, '')
		.replace(/<title>(\w|\W)+?<\/title>/ig, '')
		.replace(/\s?id="[^"]+"/ig, '')
		.replace(/\s?class="[^"]+"/ig, '')
		.replace(/\s+style="[^"]+"/ig, '')
		.replace(/\s?id='[^']+'/ig, '')
		.replace(/\s?class='[^']+'/ig, '')
		.replace(/\s+style='[^']+'/ig, '')
		.replace(/<li><p>(.*?)<\/p>(?:\n|\s)*<\/li>/gi,'<li>$1</li>')
		.replace(/<(div|p)><br><\/(div|p)>/ig, '<br><br>')
		.replace(/<div>[·•](.*?)<\/div>/ig, '<p>• $1</p>')
		.replace(/<(meta|link|\/?o:|\/?style|\/?div|\/?std|\/?head|\/?html|body|\/?body|\/?span)[^>]*?>/ig, '')
		.replace(/<[\/]*font[^>]*>/ig,'')
		.replace(/<img[^>]*>/ig,'')
		.replace(/<a(?:.|\s|\n)*?>/ig,'')
		.replace(/<\/a>/ig,' ')
		.replace(/(<[^>]+>)+&nbsp;(<\/w+>)+/ig, '')
		.replace(/&nbsp;+/ig, '')
		.replace(/\s+v:\w+=""[^""]+""/ig, '')
		.replace(/Ã¢â‚¬â€œ/ig, '&mdash;');

	// Convert possible bullet list
	str = str.replace(/((?:<p>[·•](?:\n|\s+?)*(?:(?!<\/p>)(?:.|\n))*<\/p>\s*)+)/ig,'<ul>$1</ul>');
	str = str.replace(/((?:<p>\d+\.(?:\n|\s+?)*(?:(?!<\/p>)(?:.|\n))*<\/p>\s*)+)/ig,'<ol>$1</ol>');

	// Convert bullet list (orphan)
	str = str.replace(/(?:<p>[·•](?:\n|\s+?)*)((?:.|\n)*?)<\/p>/ig,'<li>$1</li>');
	str = str.replace(/(?:<p>\d+\.(?:\n|\s+?)*)((?:.|\n)*?)<\/p>/ig,'<li>$1</li>');

	// Remove paragraph residing in a list
	str = str.replace(/<li><p>((?:.|\n)*?)<\/p><\/li>/gi,'<li>$1</li>');

	// Kill empty paragraph and span
	str = str.replace(/<p><\/p>/gi,'');

	// Convert headers to strong
	str = str.replace(/<(h[1-6])[^>]*?>/gi,'<strong>');
  str = str.replace(/<\/(h[1-6])[^>]*?>/gi,'</strong>');

	// Convert special characters
	str = convertHtmlEntities(str);

	return str;
}

function convertHtmlEntities(str) {
	Entities = {
		// Latin-1 Entities
		' ':'nbsp',
		'¡':'iexcl',
		'¢':'cent',
		'£':'pound',
		'¤':'curren',
		'¥':'yen',
		'¦':'brvbar',
		'§':'sect',
		'¨':'uml',
		'©':'copy',
		'ª':'ordf',
		'«':'laquo',
		'¬':'not',
		'­':'shy',
		'®':'reg',
		'¯':'macr',
		'°':'deg',
		'±':'plusmn',
		'²':'sup2',
		'³':'sup3',
		'´':'acute',
		'µ':'micro',
		'¶':'para',
		'·':'middot',
		'¸':'cedil',
		'¹':'sup1',
		'º':'ordm',
		'»':'raquo',
		'¼':'frac14',
		'½':'frac12',
		'¾':'frac34',
		'¿':'iquest',
		'×':'times',
		'÷':'divide',

		// Symbols

		'ƒ':'fnof',
		'•':'bull',
		'…':'hellip',
		'′':'prime',
		'″':'Prime',
		'‾':'oline',
		'⁄':'frasl',
		'℘':'weierp',
		'ℑ':'image',
		'ℜ':'real',
		'™':'trade',
		'ℵ':'alefsym',
		'←':'larr',
		'↑':'uarr',
		'→':'rarr',
		'↓':'darr',
		'↔':'harr',
		'↵':'crarr',
		'⇐':'lArr',
		'⇑':'uArr',
		'⇒':'rArr',
		'⇓':'dArr',
		'⇔':'hArr',
		'∀':'forall',
		'∂':'part',
		'∃':'exist',
		'∅':'empty',
		'∇':'nabla',
		'∈':'isin',
		'∉':'notin',
		'∋':'ni',
		'∏':'prod',
		'∑':'sum',
		'−':'minus',
		'∗':'lowast',
		'√':'radic',
		'∝':'prop',
		'∞':'infin',
		'∠':'ang',
		'∧':'and',
		'∨':'or',
		'∩':'cap',
		'∪':'cup',
		'∫':'int',
		'∴':'there4',
		'∼':'sim',
		'≅':'cong',
		'≈':'asymp',
		'≠':'ne',
		'≡':'equiv',
		'≤':'le',
		'≥':'ge',
		'⊂':'sub',
		'⊃':'sup',
		'⊄':'nsub',
		'⊆':'sube',
		'⊇':'supe',
		'⊕':'oplus',
		'⊗':'otimes',
		'⊥':'perp',
		'⋅':'sdot',
		'\u2308':'lceil',
		'\u2309':'rceil',
		'\u230a':'lfloor',
		'\u230b':'rfloor',
		'\u2329':'lang',
		'\u232a':'rang',
		'◊':'loz',
		'♠':'spades',
		'♣':'clubs',
		'♥':'hearts',
		'♦':'diams',

		// Other Special Characters

		//'"':'quot',
		//	'&':'amp',		// This entity is automatically handled by the XHTML parser.
		//	'<':'lt',		// This entity is automatically handled by the XHTML parser.
		//'>':'gt',			// Opera and Safari don't encode it in their implementation
		'ˆ':'circ',
		'˜':'tilde',
		' ':'ensp',
		' ':'emsp',
		' ':'thinsp',
		'‌':'zwnj',
		'‍':'zwj',
		'‎':'lrm',
		'‏':'rlm',
		'–':'ndash',
		'—':'mdash',
		'‘':'lsquo',
		'’':'rsquo',
		'‚':'sbquo',
		'“':'ldquo',
		'”':'rdquo',
		'„':'bdquo',
		'†':'dagger',
		'‡':'Dagger',
		'‰':'permil',
		'‹':'lsaquo',
		'›':'rsaquo',
		'€':'euro'
	};

	// Process all entities
	for ( e in Entities ) {
		var sRegexPattern = '[' + e + ']';
		re = new RegExp( sRegexPattern, 'g' );
		str = str.replace(re,'&'+Entities[ e ]+';');
	}

	return str;
}

function setEndOfContenteditable(contentEditableElement)
{
	var range,selection;
	if(document.createRange)//Firefox, Chrome, Opera, Safari, IE 9+
	{
			range = document.createRange();//Create a range (a range is a like the selection but invisible)
			range.selectNodeContents(contentEditableElement);//Select the entire contents of the element with the range
			range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
			selection = window.getSelection();//get the selection object (allows you to change selection)
			selection.removeAllRanges();//remove any selections already made
			selection.addRange(range);//make the range you have just created the visible selection
	}
	else if(document.selection)//IE 8 and lower
	{
			range = document.body.createTextRange();//Create a range (a range is a like the selection but invisible)
			range.moveToElementText(contentEditableElement);//Select the entire contents of the element with the range
			range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
			range.select();//Select the range (make it the visible selection
	}
}

$(function(){

	var $toolbar = $('<div class="btn-group editor-toolbar" data-role="editor-toolbar" style="margin-bottom:5px;display:block;">'+
					 '<a class="btn btn-small" data-edit="bold" title="Bold (Ctrl/Cmd+B)"><strong>Bold</strong></a>'+
					 '<a class="btn btn-small" data-edit="italic" title="Italic (Ctrl/Cmd+I)"><em>Italic</em></a>'+
					 '<a class="btn btn-small" data-edit="insertunorderedlist" title="Bullet list" style="min-height:20px;"><i class="icon-list-2"></i></a>'+
					 '<a class="btn btn-small" data-edit="insertorderedlist" title="Ordered list" style="min-height:20px;"><i class="icon-numbered-list"></i></a>'+
					 '</div>');

	$('[data-wysiwyg]').each(function(e){
		var $this = $(this),
			$editor = null,
			$text = null,
			id = $this.attr('id'),
			name = $this.attr('name'),
			height = ($this.outerHeight() > 18) ? $this.outerHeight() : 218,
			$tool = $toolbar.clone().attr('data-target', id + '-wysiwyg'),
			original,
			cleanhtml,
			validator,
			isDisable = $this.disabled,
			isReadOnly = $this.readOnly,
			timer = false,
			timerpaste = false;

		if(Modernizr.contenteditable) {
			if(!id) return;

			$this.before($tool);
			$this.after($('<div />').attr('id', id + '-wysiwyg'));
			$this.after($('<input type="hidden" data-validate="{ maxlength:8000 }" />').attr('id', id + '-textonly').attr('name', id + '-textonly'));
			$this.parent().append('<div style="clear:both" />');
			$this.parent().append('<label class="error" for='+ name +' generated="true" style="display: none;"></label>');
			$this.parent().append('<label class="error" for='+ id + '-textonly' +' generated="true" style="display: none;"></label>');
			$this.prop("disabled");
			$this.attr('tabindex','-1');
			$this.css({ width:0, height:0, opacity:0, padding:0, position:"absolute" });
			$this.parent().addClass('wysiwyg-container');

			$editor = $('#' + id + '-wysiwyg');
			$text = $('#' + id + '-textonly');

			// Reinit validator
			try { validator = $this.closest('form').validate(); } catch(e) {}

			if($editor){
				original = htmlDecode($this.val());
				$editor.html(original);
				$text.val(strip($editor.text()));
				$editor.attr('class', $this.attr('class'));
				//$editor.outerHeight( height );
				$editor.css({ minHeight: height });
				$editor.addClass('wysiwyg');
				if(!isDisable || !isReadOnly){
					$editor.wysiwyg({
						hotKeys: {
							'ctrl+b meta+b': 'bold',
							'ctrl+i meta+i': 'italic',
							'ctrl+z meta+z': 'undo',
							'ctrl+y meta+y meta+shift+z': 'redo'
						}
					});
				} else {
					$editor.addClass('disabled');
				}
			}

			if(!isDisable || !isReadOnly){
				$editor.on('keyup paste',function(){
					if(!timer) {
						timer = true;
						setTimeout(function(){
							cleanhtml = htmlEncode($editor.cleanHtml());
							$this.val( cleanhtml );
							$text.val( strip(cleanhtml) );
							$this.trigger('keyup');
							try { validator.element('#'+ id + '-textonly'); } catch(e) {}
							if(cleanhtml !== original) {
								$this.trigger('change');
							}
							timer = false;
						},500);
					}
				});

				$editor.on('paste',function(){
					if(!timerpaste) {
						timerpaste = true;
						setTimeout(function(){
							cleanhtml = cleanDocHtml($editor.cleanHtml());
							$editor.html(cleanhtml);
							setEndOfContenteditable($editor[0]);
							timerpaste = false;
						},10);
					}
				});

				$tool.on('click','.btn',function(){
					$text.val(strip($editor.html()));
					cleanhtml = htmlEncode($editor.cleanHtml());
					$this.val( cleanhtml );
					$this.trigger('blur');
					if(cleanhtml !== original) {
						$this.trigger('change');
					}
				});

				$editor.on('load',function(){
					$text.val(strip($editor.html()));
					cleanhtml = htmlEncode($editor.cleanHtml());
					$this.val( cleanhtml );
					$this.trigger('blur');
					if(cleanhtml !== original) {
						$this.trigger('change');
					}
				});

				$editor.on('blur',function(){
					$this.trigger('blur');
					try { validator.element('#'+ id + '-textonly'); } catch(e) {}
				});
			}

		} else {
			// For those that does not have support for contentEditable inline HTML editing, fallback to text mode.

			if (!id) return;

			$this.after($('<textarea />').attr('id', id + '-wysiwyg'));
			$this.after($('<input type="hidden" data-validate="{ maxlength:8000 }" />').attr('id', id + '-textonly').attr('name', id + '-textonly'));
			$this.parent().append('<div style="clear:both" />');
			$this.parent().append('<label class="error" for='+ name +' generated="true" style="display: none;"></label>');
			$this.parent().append('<label class="error" for='+ id + '-textonly' +' generated="true" style="display: none;"></label>');
			$this.prop("disabled");
			$this.attr('tabindex','-1');
			$this.css({ width:0, height:0, opacity:0, padding:0, position:"absolute" });

			$editor = $('#' + id + '-wysiwyg');
			$text = $('#' + id + '-textonly');

			$editor.text(htmlDecode($this.val()));
			$text.val(strip(htmlDecode($this.val())));
			$editor.attr('class', $this.attr('class'));
			$editor.outerHeight( height );
			$editor.addClass('wysiwyg');

			if(!isDisable || !isReadOnly){

			} else {
				$editor.prop('disabled',true);
			}

			original = htmlEncode($editor.text());

			// Reinit validator
			try { validator = $this.closest('form').validate(); } catch(e) {}

			if(!isDisable || !isReadOnly){

				$editor.closest('form').on('submit',function(){
					cleanhtml = htmlEncode($editor.val());
					$this.val( cleanhtml );
					$text.val(strip(cleanhtml));
					$this.trigger('keyup');
				});

				$editor.on('blur',function(){
					cleanhtml = htmlEncode($editor.val());
					$this.val( cleanhtml );
					$text.val(strip(cleanhtml));
					$this.trigger('blur');
					try { validator.element('#'+ id + '-textonly'); } catch(e) {}
				});
			}

		}


	});

});