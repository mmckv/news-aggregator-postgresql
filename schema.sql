-- If you want to run this schema repeatedly you'll need to drop
-- the table before re-creating it. Note that you'll lose any
-- data if you drop and add a table:

DROP TABLE IF EXISTS articles;
CREATE TABLE articles (
id SERIAL PRIMARY KEY,
title VARCHAR(200),
url VARCHAR(200),
description VARCHAR(500)
);
