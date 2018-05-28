/******* join-us section ********/
p.join-us,
a.join-us,
a.join-us:focus,
a.join-us:active
{
	color: #707b82;
}

a.join-us:hover {
	color: #d9403d;
}

a.join-us-button {
	display: block;
	margin: auto;
	width: 40%;
}

a.join-us-button:hover {
	background-color: #d9403d;
}

.center-justify {
	text-align: justify;
	-moz-text-align-last: center;
	text-align-last: center;
}

/* Our Mission */
.mission-separator1 {
	height: 100px;
}

.mission-separator2 {
	height: 0px;
}


.our-mission-header {
	text-shadow: 4px 4px 0.9 #000000;
	font-size: 40px !important;
}

.our-mission {
	font-size: 18px !important;
	text-align: justify;
	text-shadow: 4px 4px 0.9 #000000;
}

/* Our Values */
.our-values-header {
	text-shadow: 4px 4px 0.9 #000000;
	font-family: Lato;
	text-transform: none;
	font-size: 50px !important;
	font-weight: lighter;
	text-align: center;
}

.our-values {
	margin-left: auto;
	margin-right: auto;
	/*width: 25em;*/
	word-spacing: 40%;
	letter-spacing: 0.0505em;
	text-align: justify;
	text-justify: inter-word;
	font-family: Sans-Serif;
	font-size: 20px !important;
	font-weight: 200;
	color: #8c8c8c;
	line-height: 22px;
}

.our-values2 {
	font-size: 18px !important;
	text-align: justify;
	text-shadow: 4px 4px 0.9 #000000;
}

.our-values-keyword {
	margin-left: auto;
	margin-right: auto;
	/*width: 25em;*/
	word-spacing: 40%;
	letter-spacing: 0.0505em;
	text-align: justify;
	text-justify: inter-word;
	font-family: Sans-Serif;
	font-size: 20px !important;
	font-weight: 500;
	color: #8c8c8c;
	line-height: 22px;
}

.our-values-captation {
	margin-left: auto;
	margin-right: auto;
	width: 90%;
	word-spacing: 40%;
	letter-spacing: 0.0505em;
	text-align: justify;
	text-justify: inter-word;
	font-family: Sans-Serif;
	font-size: 18px !important;
	font-weight: 200;
	color: #8c8c8c;
	line-height: 20px;
	float: bottom;
	
	padding-bottom: 1em;
}

.our-values-description {
	margin-left: auto;
	margin-right: auto;
	width: 50em;
	word-spacing: 40%;
	letter-spacing: 0.0505em;
	text-align: justify;
	text-justify: inter-word;
	font-family: Sans-Serif;
	font-size: 12px;
	font-weight: 200;
	color: #8c8c8c;
	line-height: 14px;
}

span.our-values-keyword {
	color: #d9403d;
}

p.our-values-vertical-center {
	display: table-cell;
    vertical-align: middle;
    padding: 5.0em;
}

table.our-values-table {
	width: 60em;
	margin-left: auto;
	margin-right: auto;

	word-spacing: 40%;
	letter-spacing: 0.0505em;
	text-align: justify;
	text-justify: inter-word;
	font-family: Sans-Serif;
	font-size: 18px !important;
	font-weight: 200;
	color: #8c8c8c;
	line-height: 16px;	

	border-spacing: 40px;	
}

td.our-values-td-1 {
	vertical-align: top;
	
	padding-right: 1em;
}

.values-container {
	float: left;
	overflow: hidden;
	width: 80%;
	margin-left: 5em;
}

.mission-standout_font {
	font-size: 20px;
}

.values-keyword {
	font-weight: 200;
	font-size: 20px;			
	float: top;
	/*overflow: hidden;*/
	width: 80%;
	text-align: left;
	visibility: hidden;
}

.values-description {
	font-weight: 100;
	font-size: 20px;
	text-align: justify;
	text-justify: inter-word;
	word-spacing: 40%;
	letter-spacing: 0.05em;
	line-height: 22px;
	margin-left: auto;
	margin-right: auto;
	float: bottom;
	overflow: hidden;
	/*width: 80%;*/
	padding-bottom: 10px;
	visibility: hidden;
}


/* Desktop */
@media only screen and (min-width: 1024px) {
	.mission-separator1 {
		height: 200px;
	}

	.mission-separator2 {
		height: 50px;
	}

	.our-mission-header {
		text-shadow: 4px 4px 0.9 #000000;
		font-size: 40px !important;
	}

	.our-mission {
		font-size: 28px !important;
		text-align: justify;
		text-shadow: 4px 4px 0.9 #000000;
	}

	.mission-text-heading {
		font-family: Sans-Serif;
		font-weight: 400;
		font-size: 32px;
		text-align: center;
		padding-bottom: 40px;
	}

	.mission-text-content {
		font-family: Sanf-Serif;
		font-weight: 200;
		font-size: 20px;
		text-align: justify;
		text-justify: inter-word;
		word-spacing: 40%;
		letter-spacing: 0.05em;
		line-height: 22px;
		width: 50%;
		margin-left: auto;
		margin-right: auto;
	}

	.separator {
		padding-bottom: 40px;
	}

	.values-container {
		float: left;
		overflow: hidden;
		width: 80%;
		margin-left: 200px;
	}

	.values-keyword {
		margin-left: auto;
		font-weight: 200;
		font-size: 18px;			
		float: left;
		width: 20%;
		visibility: visible;
		/*overflow: hidden;*/
	}

	.values-description {
		font-weight: 100;
		font-size: 14px;
		text-align: justify;
		text-justify: inter-word;
		word-spacing: 40%;
		letter-spacing: 0.05em;
		line-height: 16px;
		margin-left: auto;
		margin-right: auto;
		float: left;
		overflow: hidden;
		width: 70%;
		visibility: visible;
	}
}

/* Why Us? */
p.why-us {
	width: 50%;
	margin-left: auto;
	/*margin-right: auto;*/
	margin-right: 200px;
	text-align: justify;
	text-justify: inter-word;
	line-height: 40px !important;
}

.why-us-header {
	width: 100%;
	text-shadow: 4px 4px 0.9 #000000;
	font-family: Lato;
	text-transform: none;
	font-size: 40px;
	font-weight: normal;
	/*text-align: center;*/
	margin-left: auto;
	margin-right: 200px;
}

.why-us-values {
	margin-left: auto;
	margin-right: auto;
	width: 24em;
	word-spacing: 40%;
	letter-spacing: 0.0505em;
	text-align: justify;
	text-justify: inter-word;
	font-family: Sans-Serif;
	font-size: 36px;
	font-weight: 200;
	color: #8c8c8c;
	line-height: 60px;
}

span.why-us-values {
	color: #d9403d;
}

p.why-us-vertical-center {
	display: table-cell;
    vertical-align: middle;
    padding: 5.0em;
}

/* Tooltips */
#hint {
	cursor: pointer;
}

.definition-tooltip {
	margin: 8px;
	padding: 8px;
	/*border: 1px solid #d9403d;*/
	background-color: white;
	position: absolute;
	z-index: 1000000000;
	display: inline-block;
	width: 700px;
	text-align: justify;
	font-family: Sans-Serif;
	font-size: 18px;
	font-weight: 200;
	color: #8c8c8c;
	line-height: 25px;
	box-shadow: rgba(0,0,0,0.6) 0 8px 16px;
}

/* Arrows in Carousel */
.arrow-color {
	color: lightgray;
}

.slider-height {
	height: 500px;
}

.slider-bottom {
	top: 600px;
}

/* Hovers in Wallboards */

.mission:hover {
	text-decoration: underline;
}

.values:hover {
	text-decoration: underline;
}

table.why-us-table {
	background: none repeat scroll 0 0 rgba(0, 0, 0, 0.5);
}

td.why-us-table, th.why-us-table {
	padding: 10px;
}

.service-container {
	width: 80%;
	margin-left: auto;
	margin-right: auto;
}

.service-col-1 {
	float: left;
	width: 50%;
}

.service-col-2 {
	float: right:
	width: 50%;
}

.menu-padding {
	padding-top: 30px;
}




.grid > div {
	display: flex;
}

.grid > div > div {
	flex: 1;
	position: relative;
}

.grid > div > div::before {
	content: '';
	display: block;
	padding-bottom: 50px;
}

.grid > div > div > div {
	position: absolute;
	top 0;
	left: 0;
	right: 0;
	bottom: 0;
}

@media (min-width:813px)
{

.certificationsHideDesktop {
 display: none
}
}
/*Mobile */
@media (min-width:320px) and (max-width:813px)
{
.service-col-1 {
	float: left;
	width: 100%;
}


.values-container {
    float: left;
    overflow: hidden;
    width: calc(100% - 20px) !important;
    margin-left: 10px;
    margin-right: 10px;
    padding-left: 0 !important;
}



p.why-us{
	width: 95%;
	line-height: 30px !important;
}

.mission-standout_font {
	font-size: 4.6vw;
}


.certificationsHideMobile {
	display: none
}

.certifications--margin{
 	margin: 2px;
 	height: 58px;
    width: 101.42px;
}

.carousel-indicators{
	top: 3%;
}
}
