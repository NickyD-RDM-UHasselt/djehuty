-------------------------------------------------------------------------------
-- ARTICLES
-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS License(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name                  VARCHAR(128),
    url                   VARCHAR(255)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Timeline(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    posted                datetime,
    submission            datetime,
    revision              datetime,
    firstOnline           datetime,
    publisherPublication  datetime,
    publisherAcceptance   datetime) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Institution(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name                  VARCHAR(255)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ArticleEmbargoOptionGroup(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name                  VARCHAR(255)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ArticleEmbargoOption(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type                  VARCHAR(32),
    ip_name               VARCHAR(255),
    group_id              INT UNSIGNED,

    FOREIGN KEY (group_id) REFERENCES ArticleEmbargoOptionGroup(id))
    ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ArticleEmbargo(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date                  datetime,
    title                 VARCHAR(255),
    reason                VARCHAR(255)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Article(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title                 VARCHAR(255),
    doi                   VARCHAR(255),
    handle                VARCHAR(255),
    group_id              INT DEFAULT NULL,
    url                   VARCHAR(255),
    url_public_html       VARCHAR(255),
    url_public_api        VARCHAR(255),
    url_private_html      VARCHAR(255),
    url_private_api       VARCHAR(255),
    published_date        VARCHAR(32),
    timeline_id           INT UNSIGNED,
    thumb                 VARCHAR(255),
    defined_type          INT,
    defined_type_name     VARCHAR(255),
    embargo_id            INT UNSIGNED,

    -- The following fields are inferred from the search interfaces
    -- rather than the data descriptions.  For example, an article
    -- must be linked to an institution somehow, but needs not
    -- necessarily be implemented using a foreign key.
    institution_id        INT UNSIGNED,
    is_private            BOOLEAN NOT NULL DEFAULT 0,

    FOREIGN KEY (institution_id) REFERENCES Institution(id),
    FOREIGN KEY (timeline_id)    REFERENCES Timeline(id),
    FOREIGN KEY (embargo_id)     REFERENCES ArticleEmbargo(id)) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS ArticleComplete(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    figshare_url          VARCHAR(255),
    resource_title        VARCHAR(255),
    resource_doi          VARCHAR(255),
    files_id              INT UNSIGNED,
    authors_id            INT UNSIGNED,
    custom_fields_id      INT UNSIGNED,
    embargo_options_id    INT UNSIGNED,
    citation              VARCHAR(255),
    confidential_reason   VARCHAR(255),
    embargo_type          VARCHAR(255),
    is_confidential       BOOLEAN NOT NULL DEFAULT 0,
    size                  INT UNSIGNED,
    funding               VARCHAR(255),
    funding_id            INT UNSIGNED,
    tags_id               INT UNSIGNED,
    version               INT UNSIGNED,
    is_active             BOOLEAN NOT NULL DEFAULT 1,
    is_metadata_record    BOOLEAN NOT NULL DEFAULT 0,
    metadata_reason       VARCHAR(255),
    status                VARCHAR(255),
    description           VARCHAR(512),
    is_embargoed          BOOLEAN NOT NULL DEFAULT 0,
    embargo_date          DATETIME,
    is_public             BOOLEAN NOT NULL DEFAULT 1,
    modified_date         DATETIME,
    created_date          DATETIME,
    has_linked_file       BOOLEAN NOT NULL DEFAULT 0,
    categories_id         INT UNSIGNED,
    license_id            INT UNSIGNED,
    embargo_title         VARCHAR(255),
    embargo_reason        VARCHAR(255),
    references_id         INT UNSIGNED,
    article_id            INT UNSIGNED,

    FOREIGN KEY (article_id) REFERENCES Article(id),
    FOREIGN KEY (license_id) REFERENCES License(id)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS PublicFile(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name                  VARCHAR(255),
    size                  INT UNSIGNED,
    is_link_only          BOOLEAN NOT NULL DEFAULT 0,
    download_url          VARCHAR(255),
    supplied_md5          VARCHAR(64),
    computed_md5          VARCHAR(64)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AuthorComplete(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    institution_id        INT UNSIGNED,
    group_id              INT UNSIGNED,
    first_name            VARCHAR(255),
    last_name             VARCHAR(255),
    is_public             BOOLEAN NOT NULL DEFAULT 1,
    job_title             VARCHAR(255),

    -- Can this be inferred from first_name and last_name?
    full_name             VARCHAR(255),

    is_active             BOOLEAN NOT NULL DEFAULT 1,
    url_name              VARCHAR(255),
    orcid_id              VARCHAR(255)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS CustomArticleField(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name                  VARCHAR(255),
    value                 VARCHAR(255),
    is_mandatory          BOOLEAN NOT NULL DEFAULT 0) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS GroupEmbargoOptions(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    type                  ENUM('logged_in', 'ip_range', 'administrator'),
    ip_name               VARCHAR(255)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Category(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    parent_id             INT UNSIGNED,
    title                 VARCHAR(255)) ENGINE=InnoDB;

-------------------------------------------------------------------------------
-- COLLECTIONS
-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Collection(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title                 VARCHAR(255),
    doi                   VARCHAR(255),
    handle                VARCHAR(255),
    url                   VARCHAR(255),
    timeline_id           INT UNSIGNED,
    published_date        DATETIME,

    FOREIGN KEY (timeline_id) REFERENCES Timeline(id)) ENGINE=InnoDB;

-------------------------------------------------------------------------------
-- PROJECTS
-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Project(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title                 VARCHAR(255),
    url                   VARCHAR(255),
    published_date        DATETIME) ENGINE=InnoDB;

-------------------------------------------------------------------------------
-- INSTITUTIONS
-------------------------------------------------------------------------------

-- See table Institution above.

-------------------------------------------------------------------------------
-- AUTHORS
-------------------------------------------------------------------------------

-- See table AuthorComplete above.

-------------------------------------------------------------------------------
-- ACCOUNTS
-------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Account(
    id                    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    active                INT,
    created_date          DATETIME,
    email                 VARCHAR(255),
    first_name            VARCHAR(255),
    group_id              INT,
    institution_id        INT,
    institution_user_id   VARCHAR(255),
    last_name             VARCHAR(255),
    maximum_file_size     INT,
    modified_date         DATETIME,
    pending_quota_request BOOLEAN NOT NULL DEFAULT 0,
    quota                 INT,
    used_quota            INT,
    used_quota_private    INT,
    used_quota_public     INT) ENGINE=InnoDB;
