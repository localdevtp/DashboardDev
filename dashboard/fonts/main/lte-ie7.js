/* Load this script using conditional IE comments if you need to support IE 7 and IE 6. */

window.onload = function() {
	function addIcon(el, entity) {
		var html = el.innerHTML;
		el.innerHTML = '<span style="font-family: \'main\'">' + entity + '</span>' + html;
	}
	var icons = {
			'icon-home' : '&#xe000;',
			'icon-newspaper' : '&#xe001;',
			'icon-pencil' : '&#xe002;',
			'icon-image' : '&#xe003;',
			'icon-camera' : '&#xe004;',
			'icon-play' : '&#xe005;',
			'icon-file' : '&#xe006;',
			'icon-profile' : '&#xe007;',
			'icon-file-2' : '&#xe008;',
			'icon-file-3' : '&#xe009;',
			'icon-folder' : '&#xe00a;',
			'icon-folder-open' : '&#xe00b;',
			'icon-tag' : '&#xe00c;',
			'icon-barcode' : '&#xe00d;',
			'icon-location' : '&#xe00e;',
			'icon-location-2' : '&#xe00f;',
			'icon-pushpin' : '&#xe010;',
			'icon-envelop' : '&#xe011;',
			'icon-address-book' : '&#xe012;',
			'icon-notebook' : '&#xe013;',
			'icon-phone-hang-up' : '&#xe014;',
			'icon-phone' : '&#xe015;',
			'icon-support' : '&#xe016;',
			'icon-calculate' : '&#xe017;',
			'icon-credit' : '&#xe018;',
			'icon-cart' : '&#xe019;',
			'icon-cart-2' : '&#xe01a;',
			'icon-qrcode' : '&#xe01b;',
			'icon-compass' : '&#xe01c;',
			'icon-map' : '&#xe01d;',
			'icon-clock' : '&#xe01e;',
			'icon-bell' : '&#xe01f;',
			'icon-print' : '&#xe020;',
			'icon-screen' : '&#xe021;',
			'icon-laptop' : '&#xe022;',
			'icon-mobile' : '&#xe023;',
			'icon-keyboard' : '&#xe024;',
			'icon-calendar' : '&#xe025;',
			'icon-mobile-2' : '&#xe026;',
			'icon-tablet' : '&#xe027;',
			'icon-tv' : '&#xe028;',
			'icon-drawer' : '&#xe029;',
			'icon-box-add' : '&#xe02a;',
			'icon-box-remove' : '&#xe02b;',
			'icon-download' : '&#xe02c;',
			'icon-upload' : '&#xe02d;',
			'icon-disk' : '&#xe02e;',
			'icon-undo' : '&#xe02f;',
			'icon-redo' : '&#xe030;',
			'icon-undo-2' : '&#xe031;',
			'icon-redo-2' : '&#xe032;',
			'icon-bubble' : '&#xe033;',
			'icon-bubbles' : '&#xe034;',
			'icon-user' : '&#xe035;',
			'icon-users' : '&#xe036;',
			'icon-user-2' : '&#xe037;',
			'icon-quotes-left' : '&#xe038;',
			'icon-busy' : '&#xe039;',
			'icon-spinner' : '&#xe03a;',
			'icon-spinner-2' : '&#xe03b;',
			'icon-spinner-3' : '&#xe03c;',
			'icon-spinner-4' : '&#xe03d;',
			'icon-spinner-5' : '&#xe03e;',
			'icon-spinner-6' : '&#xe03f;',
			'icon-binoculars' : '&#xe040;',
			'icon-search' : '&#xe041;',
			'icon-zoom-in' : '&#xe042;',
			'icon-zoom-out' : '&#xe043;',
			'icon-expand' : '&#xe044;',
			'icon-contract' : '&#xe045;',
			'icon-key' : '&#xe046;',
			'icon-lock' : '&#xe047;',
			'icon-lock-2' : '&#xe048;',
			'icon-unlocked' : '&#xe049;',
			'icon-wrench' : '&#xe04a;',
			'icon-equalizer' : '&#xe04c;',
			'icon-cog' : '&#xe04b;',
			'icon-cog-2' : '&#xe04d;',
			'icon-pie' : '&#xe04e;',
			'icon-stats' : '&#xe04f;',
			'icon-bars' : '&#xe050;',
			'icon-bug' : '&#xe051;',
			'icon-dashboard' : '&#xe052;',
			'icon-fire' : '&#xe053;',
			'icon-remove' : '&#xe054;',
			'icon-food' : '&#xe055;',
			'icon-airplane' : '&#xe056;',
			'icon-truck' : '&#xe057;',
			'icon-accessibility' : '&#xe058;',
			'icon-target' : '&#xe059;',
			'icon-shield' : '&#xe05a;',
			'icon-lightning' : '&#xe05b;',
			'icon-switch' : '&#xe05c;',
			'icon-list' : '&#xe05d;',
			'icon-list-2' : '&#xe05e;',
			'icon-numbered-list' : '&#xe05f;',
			'icon-menu' : '&#xe060;',
			'icon-link' : '&#xe061;',
			'icon-flag' : '&#xe062;',
			'icon-attachment' : '&#xe063;',
			'icon-eye' : '&#xe064;',
			'icon-eye-blocked' : '&#xe065;',
			'icon-bookmark' : '&#xe066;',
			'icon-star' : '&#xe067;',
			'icon-star-2' : '&#xe068;',
			'icon-star-3' : '&#xe069;',
			'icon-heart' : '&#xe06a;',
			'icon-heart-2' : '&#xe06b;',
			'icon-thumbs-up' : '&#xe06c;',
			'icon-thumbs-up-2' : '&#xe06d;',
			'icon-point-up' : '&#xe06e;',
			'icon-point-right' : '&#xe06f;',
			'icon-point-down' : '&#xe071;',
			'icon-point-left' : '&#xe070;',
			'icon-warning' : '&#xe072;',
			'icon-info' : '&#xe073;',
			'icon-info-2' : '&#xe074;',
			'icon-cancel-circle' : '&#xe075;',
			'icon-checkmark-circle' : '&#xe076;',
			'icon-spam' : '&#xe077;',
			'icon-close' : '&#xe078;',
			'icon-checkmark' : '&#xe079;',
			'icon-blocked' : '&#xe07a;',
			'icon-checkmark-2' : '&#xe07b;',
			'icon-spell-check' : '&#xe07c;',
			'icon-minus' : '&#xe07d;',
			'icon-plus' : '&#xe07e;',
			'icon-enter' : '&#xe07f;',
			'icon-exit' : '&#xe080;',
			'icon-backward' : '&#xe084;',
			'icon-forward' : '&#xe085;',
			'icon-first' : '&#xe086;',
			'icon-last' : '&#xe087;',
			'icon-tab' : '&#xe09e;',
			'icon-file-pdf' : '&#xe081;',
			'icon-file-openoffice' : '&#xe082;',
			'icon-file-word' : '&#xe083;',
			'icon-file-excel' : '&#xe088;',
			'icon-file-xml' : '&#xe089;',
			'icon-file-css' : '&#xe08b;',
			'icon-file-powerpoint' : '&#xe08c;',
			'icon-code' : '&#xe091;',
			'icon-ellipsis' : '&#xe092;',
			'icon-dot' : '&#xe093;',
			'icon-aid' : '&#xe094;',
			'icon-lab' : '&#xe095;',
			'icon-mug' : '&#xe096;',
			'icon-road' : '&#xe097;',
			'icon-signup' : '&#xe098;',
			'icon-tags' : '&#xe099;',
			'icon-book' : '&#xe09b;',
			'icon-connection' : '&#xe09c;',
			'icon-dice' : '&#xe09d;',
			'icon-office' : '&#xe09a;',
			'icon-home-2' : '&#xe09f;',
			'icon-wand' : '&#xe0a0;',
			'icon-boat' : '&#xe0a1;',
			'icon-motorbike' : '&#xe0a2;',
			'icon-caravan' : '&#xe0a3;',
			'icon-checkbox-checked' : '&#xe0ac;',
			'icon-checkbox-unchecked' : '&#xe0ad;',
			'icon-checkbox-partial' : '&#xe0ae;',
			'icon-radio-checked' : '&#xe0af;',
			'icon-radio-unchecked' : '&#xe0b0;',
			'icon-share' : '&#xe0b1;',
			'icon-vmenu' : '&#xe0b2;',
			'icon-paypal' : '&#xe0b3;',
			'icon-feed' : '&#xe0b4;',
			'icon-feed-2' : '&#xe0b5;',
			'icon-google-plus' : '&#xe0b6;',
			'icon-google-drive' : '&#xe0b7;',
			'icon-facebook' : '&#xe0b8;',
			'icon-twitter' : '&#xe0b9;',
			'icon-vimeo2' : '&#xe0ba;',
			'icon-chevron-left' : '&#xf053;',
			'icon-chevron-right' : '&#xf054;',
			'icon-arrow-left' : '&#xf060;',
			'icon-arrow-right' : '&#xf061;',
			'icon-arrow-up' : '&#xf062;',
			'icon-arrow-down' : '&#xf063;',
			'icon-chevron-up' : '&#xf077;',
			'icon-chevron-down' : '&#xf078;',
			'icon-image-2' : '&#xe08d;',
			'icon-images' : '&#xe08e;',
			'icon-music' : '&#xe08f;',
			'icon-camera-2' : '&#xe090;',
			'icon-bullhorn' : '&#xe0a4;',
			'icon-stack-1' : '&#xe0a5;',
			'icon-feed-3' : '&#xe0a6;',
			'icon-coin' : '&#xe0a7;',
			'icon-user-3' : '&#xe0a8;',
			'icon-trophy' : '&#xe0a9;',
			'icon-tree' : '&#xe0aa;',
			'icon-menu-2' : '&#xe0ab;',
			'icon-notification' : '&#xe0bb;',
			'icon-question' : '&#xe0bc;',
			'icon-loop' : '&#xe0bd;',
			'icon-table' : '&#xe08a;',
			'icon-insert-template' : '&#xe0be;',
			'icon-download-2' : '&#xe0bf;',
			'icon-upload-2' : '&#xe0c0;',
			'icon-briefcase' : '&#xe0c1;',
			'icon-account' : '&#xe0c2;',
			'icon-asterisk' : '&#xf069;',
			'icon-magnet' : '&#xf076;',
			'icon-document-stroke' : '&#xe0c3;',
			'icon-steering-wheel' : '&#xe0c4;',
			'icon-certificate' : '&#xf0a3;',
			'icon-fighter-jet' : '&#xf0fb;',
			'icon-stethoscope' : '&#xf0f1;',
			'icon-lightbulb' : '&#xf0eb;',
			'icon-folder-close-alt' : '&#xf114;',
			'icon-folder-open-alt' : '&#xf115;',
			'icon-filter' : '&#xe0c5;',
			'icon-filter-2' : '&#xe0c6;',
			'icon-new-tab' : '&#xe0c7;',
			'icon-strikethrough' : '&#xf0cc;',
			'icon-underline' : '&#xf0cd;',
			'icon-desktop' : '&#xf108;',
			'icon-scissors' : '&#xe0c8;',
			'icon-font' : '&#xe0c9;',
			'icon-text-height' : '&#xe0ca;',
			'icon-bold' : '&#xe0cb;',
			'icon-paragraph-left' : '&#xe0cc;',
			'icon-paragraph-center' : '&#xe0cd;',
			'icon-paragraph-right' : '&#xe0ce;',
			'icon-paragraph-justify' : '&#xe0cf;',
			'icon-indent-increase' : '&#xe0d0;',
			'icon-indent-decrease' : '&#xe0d1;',
			'icon-code-2' : '&#xe0d2;',
			'icon-console' : '&#xe0d3;',
			'icon-apple' : '&#xe0d4;',
			'icon-android' : '&#xe0d5;',
			'icon-windows8' : '&#xe0d6;',
			'icon-tux' : '&#xe0d7;'
		},
		els = document.getElementsByTagName('*'),
		i, attr, html, c, el;
	for (i = 0; ; i += 1) {
		el = els[i];
		if(!el) {
			break;
		}
		attr = el.getAttribute('data-icon');
		if (attr) {
			addIcon(el, attr);
		}
		c = el.className;
		c = c.match(/icon-[^\s'"]+/);
		if (c && icons[c[0]]) {
			addIcon(el, icons[c[0]]);
		}
	}
};