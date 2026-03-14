/*
===============================================================================
DDL Script: Create Gold Views
==================================================================================
Script Purpose:
		This view prepares sales data for the Gold layer by enriching records
		from the Silver layer. It categorizes products and produces a clean,
		business ready dataset optimized for reporting, dashboards and analytical 
		queries.
==================================================================================
*/

IF OBJECT_ID('gold.beautyspot_sales_sls', 'V') IS NOT NULL
	DROP VIEW gold.beautyspot_sales_sls;
GO
CREATE VIEW gold.beautyspot_sales_sls AS
WITH new_sales_details AS(
SELECT
	part_no,
	product_name,
	CASE 
		-- Classifies products by scanning product_name for keywords using LIKE.
		-- Each WHEN maps to a business category; evaluation is top-down.
		-- Used due to inconsistent naming and no structured category table.
		WHEN product_name LIKE '%HAIR%' OR product_name LIKE '%WIG%' OR product_name LIKE '%WEAVON%'
			OR product_name LIKE '%ATTACHMENT%' OR product_name LIKE '%BRAID%' OR product_name LIKE '%KINKY%'
			OR product_name LIKE '%CURL%' OR product_name LIKE '%LOCS%' OR product_name LIKE '%CROCHET%'
			OR product_name LIKE '%WOOL%' OR product_name LIKE '%BONNET%' OR product_name LIKE '%DURAG%'
			OR product_name LIKE '%FRONTAL%' OR product_name LIKE '%CLOSURE%' OR product_name LIKE '%NET%'
			OR product_name LIKE '%PARKER%' OR product_name LIKE '%COMB%' OR product_name LIKE '%STRAIGHTENER%'
			OR product_name LIKE '%DRYER%' OR product_name LIKE '%ROLLERS%' OR product_name LIKE '%EDGE BRUSH%'
			OR product_name LIKE '%DUMMY%' OR product_name LIKE '%T-PINS%' OR product_name LIKE '%VENTILATING PIN%'
			OR product_name LIKE '%TWIST%' OR product_name LIKE '%DREAD%' OR product_name LIKE '%SCALP%'
			OR product_name LIKE '%HEAD COVER%' OR product_name LIKE '%HEAD WARMER%' OR product_name LIKE '%ELASTIC BAND%'
			OR product_name LIKE '%THREAD%' OR product_name LIKE '%BARRET%' OR product_name LIKE '%BARBER%'
			OR product_name LIKE '%BANG LOCK SPRAY%' OR product_name LIKE '%STRETCH RUBBER%' OR product_name LIKE '%FASHION PIN%'
			OR product_name LIKE '%KOKO RUBBER%' OR product_name LIKE '%RIBBON%' OR product_name LIKE '%DARLING SUPERSTAR%'
			OR product_name LIKE '%LACE MELTING%' OR product_name LIKE '%SEWING NEEDLES%' OR product_name LIKE '%KNITTING PIN%'
			OR product_name LIKE '%SPRAY CAN%' OR product_name LIKE '%TEDDY BRUSH%' OR product_name LIKE '%VENINOW BRUSH SET%'
			THEN 'HAIR & HAIR ACCESSORIES'

		WHEN product_name Like '%FOUNDATION%' OR product_name LIKE '%POWDER%' OR product_name LIKE '%CONCEALER%'
			OR product_name LIKE '%LIPSTICK%' OR product_name LIKE '%LIP GLOSS%' OR product_name LIKE '%LIP BALM%'
			OR product_name LIKE '%LIP STAIN%' OR product_name LIKE '%LIP LINER%' OR product_name LIKE '%LIP MASK%'
			OR product_name LIKE '%PRIMER%' OR product_name LIKE '%SETTING SPRAY%' OR product_name LIKE '%FIXING SPRAY%'
			OR product_name LIKE '%SHADOW%' OR product_name LIKE '%MASCARA%' OR product_name LIKE '%EYELINER%'
			OR product_name LIKE '%KAJAL%' OR product_name LIKE '%BLUSH%' OR product_name LIKE '%BRONZER%'
			OR product_name LIKE '%HIGHLIGHTER%' OR product_name LIKE '%PALETTE%' OR product_name LIKE '%MAKEUP BRUSH%'
			OR product_name LIKE '%BLENDER%' OR product_name LIKE '%PUFF%' OR product_name LIKE '%FACE BRUSH%'
			OR product_name LIKE '%PENCIL%' OR product_name LIKE '%TALC%' OR product_name LIKE '%LIP CREAM%'
			OR product_name LIKE '%LIP THERAPY%' OR product_name LIKE '%LIP GEL%' OR product_name LIKE '%LIP OIL%'
			OR product_name LIKE '%LIPSTAIN%' OR product_name LIKE '%LIP STICK%' OR product_name LIKE '%LIP FIX%'
			OR product_name LIKE '%LIP CARE%' OR product_name LIKE '%PINK LIPS%' OR product_name LIKE '%MATTE%'
			OR product_name LIKE '%PALLETTE%' OR product_name LIKE '%PIGMENT%' OR product_name LIKE '%ILLUMINATOR%'
			OR product_name LIKE '%CONTOUR%' OR product_name LIKE '%MATTIFIER%' OR product_name LIKE '%OIL CONTROL%'
			OR product_name LIKE '%MAKE UP FIX%' OR product_name LIKE '%LOCKING SPRAY%' OR product_name LIKE '%SEAL%'
			OR product_name LIKE '%BLENDING BRUSH%' OR product_name LIKE '%BROW%' OR product_name LIKE '%SHARPENER%'
			OR product_name LIKE '%GLITTER%' OR product_name LIKE '%FACE DEFINER%' OR product_name LIKE '%LIPGLOSS%'
			OR product_name LIKE '%LIPS BALM%' OR product_name LIKE '%MAKE UP%' OR product_name LIKE '%FIX SPRAY%'
			OR product_name LIKE '%STAY ON SPRAY%' OR product_name LIKE '%POWEDER%' OR product_name LIKE '%EYE SOLUTION%'
			OR product_name LIKE '%MOIST DRIP%' OR product_name LIKE '%MAKE UO%' OR product_name LIKE '%LIPS BALM%'
			OR product_name LIKE '%ANGLE BRUSH%' OR product_name LIKE '%AVOUR GLITTER%' OR product_name LIKE '%ANGLE BRUSH%'
			OR product_name LIKE '%BOBBI BRUSH SET%' OR product_name LIKE '%BRUSH BASKET%' OR product_name LIKE '%COSMETIC COTTON%'
			OR product_name LIKE '%MIRROR%' OR product_name LIKE '%IMAN TREATMENT%' OR product_name LIKE '%LB BRUSH%'
			OR product_name LIKE '%LIP SCRUB%' OR product_name LIKE '%NAKED 2 IN%' OR product_name LIKE '%OPI BRUSH%'
			OR product_name LIKE '%RUA FIX STAY OVER%' OR product_name LIKE '%ZARON MULTIPURPOSE%' OR product_name LIKE '%KISS BEAUTY%'
		THEN 'MAKEUP PRODUCTS & TALCUM POWDERS'

		WHEN product_name LIKE '%TWEEZER%' OR product_name LIKE '%LASH%' OR product_name LIKE '%WIPES%'
			OR product_name LIKE '%CUTICLE%' OR product_name LIKE '%PATCH%' OR product_name LIKE '%ACNE%'
			OR product_name LIKE '%DERMA ROLLER%' OR product_name LIKE '%PIMPLE%' OR product_name LIKE '%TWIZZER%'
			OR product_name LIKE '%RAZOR%' OR product_name LIKE '%EYE MASK%' OR product_name LIKE '%SERUM%'
			OR product_name LIKE '%MOISTURIZER%' OR product_name LIKE '%MOISTURE CREAM%' OR product_name LIKE '%SKIN CREAM%'
			OR product_name LIKE '%SUNSCREEN%' OR product_name LIKE '%CLEANSE%' OR product_name LIKE '%BEAUTYLAND%'
			OR product_name LIKE '%BEAUTY LAND%' OR product_name LIKE '%BEAUTY TOOL%' OR product_name LIKE '%FRESH LOOK COL%'
			OR product_name LIKE '%COTTON ROUNDS PAD%'
		THEN 'BEAUTY PRODUCTS'

		WHEN product_name LIKE '%PEDICURE%' OR product_name LIKE '%MANICURE%' OR product_name LIKE '%FILE%'
			OR product_name LIKE '%FOOT STONE%' OR product_name LIKE '%NAIL CUTTER%' OR product_name LIKE '%BUFFER%'
			OR product_name LIKE '%NAIL%' OR product_name LIKE '%GEL POLISH%' OR product_name LIKE '%ACRYLIC POWDER%'
			OR product_name LIKE '%ACRYLIC LIQUID%' OR product_name LIKE '%NAIL REMOVER%' OR product_name LIKE '%DISSOLVER%'
			OR product_name LIKE '%CUTICLE OIL%' OR product_name LIKE '%CUTICLE REMOVER%' OR product_name LIKE '%PEDI SET%'
			OR product_name LIKE '%BLADE%' OR product_name LIKE '%NAIL TOOL%' OR product_name LIKE '%PEDI%'
			OR product_name LIKE '%PENDICURE%' OR product_name LIKE '%MANUCURE%' OR product_name LIKE '%FOOT SCRAPPER%'
			OR product_name LIKE '%FOOT MASK%' OR product_name LIKE '%SCISSORS%' OR product_name LIKE '%SUPER GLUE%'
			OR product_name LIKE '%SCISSOR%' OR product_name LIKE '%SISSORS%' OR product_name LIKE '%ACRYLIC%'
		THEN'PEDICURE & MANICURE ACCESSORIES'

		WHEN product_name LIKE '%SPONGE%' OR product_name LIKE '%BATH GLOVE%' OR product_name LIKE '%BATH ROPE%'
			OR product_name LIKE '%SHOWER CAP%' OR product_name LIKE '%TOWEL%' OR product_name LIKE '%COTTON WOOL%'
			OR product_name LIKE '%COTTON PAD%' OR product_name LIKE '%MASSAGER%' OR product_name LIKE '%MASSAGE ROLLER%'
			OR product_name LIKE '%BODY SHAPER%' OR product_name LIKE '%TOILET BAG%' OR product_name LIKE '%BATH BRUSH%'
			OR product_name LIKE '%SOAP BAR SAVER%' OR product_name LIKE '%COTTON BALL%' OR product_name LIKE '%COSMETIC PAD%'
			OR product_name LIKE '%HYDROPHILE%' OR product_name LIKE '%HAND MASK%' OR product_name LIKE '%SEA SALT%'
			OR product_name LIKE '%SPRAY BOTTLE%' OR product_name LIKE '%SPA HEADBAND%' OR product_name LIKE '%WRISTBAND%'
			OR product_name LIKE '%TRAVEL BOTTLES%' OR product_name LIKE '%DEE BEAUTY TRAVEL SET%' 
		THEN 'BODY CARE PRODUCTS'

		WHEN product_name LIKE '%RING%' OR product_name LIKE '%NECKLACE%' OR product_name LIKE '%CHAIN%'
			OR product_name LIKE '%WAIST BEAD%' OR product_name LIKE '%HAND BEAD%' OR product_name LIKE '%BANGLE%'
			OR product_name LIKE '%BRACELET%' OR product_name LIKE '%PENDANT%' OR product_name LIKE '%BROCH%'
			OR product_name LIKE '%JEWELRY%' OR product_name LIKE '%WATCH%' OR product_name LIKE '%EYE GLASS%'
			OR product_name LIKE '%SUNGLASS%' OR product_name LIKE '%SUNSHADE%' OR product_name LIKE '%GLASS CASE%'
			OR product_name LIKE '%CUFFLINKS%' OR product_name LIKE '%CORAL BEAD%' OR product_name LIKE '%CULTURAL BEAD%'
			OR product_name LIKE '%NECK BEAD%' OR product_name LIKE '%LEG BEAD%' OR product_name LIKE '%CROWN%'
			OR product_name LIKE '%SUN SHADE%' OR product_name LIKE '%CONTACT LENS%' OR product_name LIKE '%LENS SOLUTION%'
			OR product_name LIKE '%TIE CLIP%' OR product_name LIKE '%CHILDREN%' OR product_name LIKE '%CULTURAL CORAL  BEAD 1%'
			OR product_name LIKE '%GLASS CAS%' OR product_name LIKE '%WEDDING CASE%'
		THEN 'JEWELRIES,WRISTWATCHES & GLASSES'

		WHEN product_name LIKE '%BRA%' OR product_name LIKE '%PANT%' OR product_name LIKE '%BOXER%'
			OR product_name LIKE '%CAMISOL%' OR product_name LIKE '%SINGLET%' OR product_name LIKE '%GOWN%'
			OR product_name LIKE '%TROUSER%' OR product_name LIKE '%LEGGINGS%' OR product_name LIKE '%T-SHIRT%'
			OR product_name LIKE '%TOP%' OR product_name LIKE '%LINGERIE%' OR product_name LIKE '%SOCKS%'
			OR product_name LIKE '%SHOE%' OR product_name LIKE '%SLIPPERS%' OR product_name LIKE '%SANDAL%'
			OR product_name LIKE '%HEEL%' OR product_name LIKE '%CAP%' OR product_name LIKE '%HAT%'
			OR product_name LIKE '%BERET%' OR product_name LIKE '%SCARF%' OR product_name LIKE '%BELT%'
			OR product_name LIKE '%BAG%' OR product_name LIKE '%PURSE%' OR product_name LIKE '%WALLET%'
			OR product_name LIKE '%POLO%' OR product_name LIKE '%WRAP%' OR product_name LIKE '%TRAINER%'
			OR product_name LIKE '%BATH ROBE%' OR product_name LIKE '%ANKARA%' OR product_name LIKE '%BIKERS SHORT%'
			OR product_name LIKE '%VEST%' OR product_name LIKE '%CARDIGAN%' OR product_name LIKE '%SLIPPER%'
			OR product_name LIKE '%TIE%' OR product_name LIKE '%PACKET TIE%' OR product_name LIKE '%TRAVEL BOTTLING SET%'
			OR product_name LIKE '%TIGHT%' OR product_name LIKE '%BOOBS TAPE%' OR product_name LIKE '%STOCK PALM%'
			OR product_name LIKE '%TRAVELLING BOX%' OR product_name LIKE '%CARD HOLDER%' 
		THEN 'BODY-WEARS/FOOT-WEARS/BAGS & BOXES'

		WHEN product_name LIKE '%LED LIGHT%' OR product_name LIKE '%TRIPOD%' OR product_name LIKE '%QUADRAPOD%'
			OR product_name LIKE '%VIDEO LIGHT%' OR product_name LIKE '%GIMBAL%' OR product_name LIKE '%MIRROR WITH LIGHT%'
			OR product_name LIKE '%SELFIE STICK%' OR product_name LIKE '%MASSAGE GUN%' OR product_name LIKE '%ELECTRIC TOOTH BRUSH%'
			OR product_name LIKE '%SONIC TOOTHBRUSH%' OR product_name LIKE '%ORAL IRRIGATOR%' OR product_name LIKE '%SONIC ELECTRIC%'
			OR product_name LIKE '%TOOTHBRUSH MASSAGE%'
		THEN 'BEAUTY ACCESSORIES/ELECTRONICS'

		ELSE 'OTHERS'
	END AS product_category,
	qty,
	sales_N,
	cost_N,
	profit_N,
	sales_date
FROM silver.beautyspot_sales_sls
)
SELECT
	part_no AS part_number, 
	product_name,
	product_category,
	qty AS quantity,
	sales_N AS sales_amount_NGN,
	cost_N AS total_cost_NGN,
	profit_N AS total_profit_NGN,
	sales_date
FROM new_sales_details;



