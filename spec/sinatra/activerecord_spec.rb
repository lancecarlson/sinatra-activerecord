require 'spec_helper'

describe "the sinatra extension" do
  before(:each) do
    @app = Class.new(MockSinatraApp)
  end

  let(:test_database_url) { "sqlite:///foo.db" }

  it "exposes the database object" do
    @app.set :database, test_database_url
    @app.should respond_to(:database)
  end

  it "establishes the database connection when set" do
    @app.set :database, test_database_url
    @app.database.should respond_to(:table_exists?)
  end

  it "creates the database file" do
    @app.set :database, test_database_url
    @app.database.connection
    File.exists?('foo.db').should be_true

    FileUtils.rm 'foo.db'
  end

  it "can have the SQLite database in a folder" do
    FileUtils.mkdir "db"
    @app.set :database, "sqlite:///db/foo.db"
    @app.database.connection
    File.exists?('db/foo.db').should be_true

    FileUtils.rm_rf 'db'
  end
end
