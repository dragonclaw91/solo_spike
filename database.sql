 CREATE TABLE "users" (
	"id" serial NOT NULL,
	"username" varchar(255) NOT NULL,
	"password" varchar(255) NOT NULL,
	"first_name" varchar(255) NOT NULL,
	"last_name" varchar(255) NOT NULL,
	CONSTRAINT "users_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "book" (
	"id" serial NOT NULL,
	"title" varchar(255) NOT NULL,
	"author" varchar(255) NOT NULL,
	"loaned_out" BOOLEAN NOT NULL DEFAULT 'false',
	"on_loan" BOOLEAN NOT NULL DEFAULT 'false',
	"format_id" serial NOT NULL,
	"series_id" serial NOT NULL,
	"user_id" integer NOT NULL,
	"rating_id" serial NOT NULL,
	"summary" varchar(9550),
	"image_url" varchar(10000),
	CONSTRAINT "book_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "genres" (
	"id" serial NOT NULL,
	"genre_name" varchar(255) NOT NULL,
	CONSTRAINT "genres_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "series" (
	"id" serial NOT NULL,
	"series_name" varchar(255),
	CONSTRAINT "series_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "format" (
	"id" serial NOT NULL,
	"format_type" varchar(255) NOT NULL,
	CONSTRAINT "format_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "rating" (
	"id" serial NOT NULL,
	"author_rating" integer,
	"book_rating" integer,
	"series_rating" integer,
	CONSTRAINT "rating_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "book_genre" (
	"id" serial NOT NULL,
	"book_id" serial NOT NULL,
	"genre_id" serial NOT NULL,
	CONSTRAINT "book_genre_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);




ALTER TABLE "book" ADD CONSTRAINT "book_fk0" FOREIGN KEY ("format_id") REFERENCES "format"("id");
ALTER TABLE "book" ADD CONSTRAINT "book_fk1" FOREIGN KEY ("series_id") REFERENCES "series"("id");
ALTER TABLE "book" ADD CONSTRAINT "book_fk2" FOREIGN KEY ("user_id") REFERENCES "users"("id");
ALTER TABLE "book" ADD CONSTRAINT "book_fk3" FOREIGN KEY ("rating_id") REFERENCES "rating"("id");





ALTER TABLE "book_genre" ADD CONSTRAINT "book_genre_fk0" FOREIGN KEY ("book_id") REFERENCES "book"("id");
ALTER TABLE "book_genre" ADD CONSTRAINT "book_genre_fk1" FOREIGN KEY ("genre_id") REFERENCES "genres"("id");


INSERT INTO "format" ("format_type") VALUES ('physical');

INSERT INTO "series" ("series_name") VALUES('null');

INSERT INTO "rating" ("author_rating","book_rating","series_rating") VALUES(3,4,null) ;

INSERT INTO "book_genre" ("book_id","genre_id") VALUES (2,1),(2,5),(2,8),(2,10),(2,11);

INSERT INTO "book_genre" ("book_id","genre_id") VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8);

INSERT INTO "book" ("user_id","title","author","summary") VALUES (1,'it ends with us','colleen hoover',null);

INSERT INTO "book" ("user_id","title","author","summary") VALUES (1,'sparing partners','john grisham',null);


SELECT book.title,book.author,loaned_out,on_loan,summary,image_url,array_agg(genres.genre_name) AS genres FROM "book" 
JOIN "book_genre" ON book_genre.book_id = book.id 
JOIN "format" ON format.id = book.format_id 
JOIN "series" ON series.id = book.series_id 
JOIN "users" ON users.id = book.user_id 
JOIN "rating" ON book.rating_id = rating.id
JOIN "genres" ON book_genre.genre_id = genres.id
GROUP BY (book.title,book.author,loaned_out,on_loan,summary,image_url);