CREATE TABLE [dbo].[FactFilm] (
	film_id				INT				 NULL,
	title				NVARCHAR (4000)  NULL,
	description			NVARCHAR (4000)  NULL,
	release_year		INT				 NULL,
	language_id			INT				 NULL,
	rental_duration		INT				 NULL,
	rental_rate			NVARCHAR (4000)  NULL,
	length				INT				 NULL,
	replacement_cost	NVARCHAR (4000)  NULL,
	rating				NVARCHAR (4000)  NULL,
	last_update			NVARCHAR (4000)  NULL,
	special_features	NVARCHAR (4000)  NULL,
	fulltext			NVARCHAR (4000)  NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);