require 'rails_helper'

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

RSpec.describe MoviesController, type: :controller do
    before do
        @movie0 = Movie.create :title=>'A', :rating=>'R', :director=>'A', :release_date=>'1-Jan-2021' 
        @movie1 = Movie.create :title=>'B', :rating=>'R', :director=>'B', :release_date=>'3-Jan-2021'
        @movie2 = Movie.create :title=>'C', :rating=>'PG', :director=>'C', :release_date=>'5-Feb-2020'
        @movie3 = Movie.create :title=>'D', :rating=>'PG', :director=>'C', :release_date=>'5-Feb-2021' 
        @movie4 = Movie.create :title=>'NoDirector', :rating=>'PG-13', :release_date=>'5-Feb-2000'
    end

    describe 'Get #similar' do
        context 'has no director' do
            it 'redirect to homepage' do
              get :similar, :id=>@movie4.id
              expect(response).to redirect_to movies_path
            end
        end
    
        context 'has a director' do
            it 'should render similar_directors with same director movies' do
                get :similar, :id=>@movie2.id
                expect(assigns[:movies]).to eq [@movie2, @movie3]
                expect(response).to render_template('similar') 
            end
        end
    end
    
    describe 'Get #index' do
        it 'returns all movies' do
          get :index
          expect(assigns[:movies]).to eq [@movie0, @movie1, @movie2, @movie3, @movie4]
        end

    end
    
    describe 'Get #show' do
       it 'returns details page of the specific movie' do
          get :show, :id=>@movie2.id
          expect(response).to render_template("show")
          expect(assigns[:movie]).to eq @movie2
       end
    end
    
    describe 'Get #new' do
       it 'returns the new page' do
           get :new
           expect(response).to render_template 'new'
        end
    end
    describe 'Get #edit' do
        it 'it display the edit page of a specific movie' do 
            get :edit, :id=>@movie2.id
            expect(response).to render_template("edit")
            expect(assigns[:movie]).to eq @movie2
        end
    end
    describe 'Put #create' do
        it 'go through create logic' do 
            put :create, :movie=> {title: 'Createmovie'}
            expect(assigns[:movie].title).to eq 'Createmovie'
        end
    end

    context 'Put #update' do
        it 'update the attributes of a specific movie and also redirect to that page' do 
            put :update, :id=>@movie0.id, :movie=> {title: 'u01', director: 'd01'}
            expect(assigns[:movie].title).to eq 'u01'
            expect(assigns[:movie].director).to eq 'd01'
            expect(response).to redirect_to movie_path(@movie0)
        end
    end
    
end