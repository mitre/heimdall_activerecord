require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe CirclesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Circle. As you add validations to Circle, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.build(:circle).attributes
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CirclesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context 'User is logged in' do
    let(:user) { FactoryBot.create(:editor) }
    before do
      db_sign_in user
    end

    describe 'GET #index' do
      it 'returns a success response' do
        create :circle, created_by: user
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        circle = create :circle, created_by: user
        get :show, params: { id: circle.to_param }, session: valid_session
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        circle = create :circle, created_by: user
        get :edit, params: { id: circle.to_param }, session: valid_session
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        let(:new_attributes) {
          { name: 'New Name', created_by_id: user.id }
        }

        it 'creates a new Circle' do
          expect {
            post :create, params: { circle: new_attributes }, session: valid_session
          }.to change(Circle, :count).by(1)
        end

        it 'redirects to the created circle' do
          valid_attributes[created_by_id: user.id]
          post :create, params: { circle: new_attributes }, session: valid_session
          expect(response).to redirect_to(Circle.last)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { circle: invalid_attributes, created_by: user }, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) {
          { name: 'New Name', created_by_id: user.id }
        }

        it 'updates the requested circle' do
          circle = create :circle, created_by: user
          put :update, params: { id: circle.to_param, circle: new_attributes }, session: valid_session
          circle.reload
          expect(circle.name).to eq('New Name')
        end

        it 'redirects to the circle' do
          circle = create :circle, created_by: user
          put :update, params: { id: circle.to_param, circle: new_attributes }, session: valid_session
          expect(response).to redirect_to(circle)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          circle = create :circle, created_by: user
          put :update, params: { id: circle.to_param, circle: invalid_attributes }, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested circle' do
        circle = create :circle, created_by: user
        expect {
          delete :destroy, params: { id: circle.to_param }, session: valid_session
        }.to change(Circle, :count).by(-1)
      end

      it 'redirects to the circles list' do
        circle = create :circle, created_by: user
        delete :destroy, params: { id: circle.to_param }, session: valid_session
        expect(response).to redirect_to(circles_url)
      end
    end

    context 'With another User is logged in' do
      let(:another_user) { FactoryBot.create(:editor) }
      let(:profile) { FactoryBot.create(:profile, created_by: user) }
      let(:evaluation) { FactoryBot.create(:evaluation, created_by: user) }

      describe 'Manage members' do
        it 'adds a member to the circle' do
          circle = create :circle, created_by: user
          put :members, format: 'js', params: { id: circle.to_param, user: { id: another_user.id } }, session: valid_session
          another_user.reload
          expect(another_user.has_role?(:member, circle)).to eq true
          delete :remove_member, format: 'js', params: { id: circle.to_param, user_id: another_user.id }, session: valid_session
          another_user.reload
          expect(another_user.has_role?(:member, circle)).to eq false
        end
      end

      describe 'Manage owners' do
        it 'adds an owner to the circle' do
          circle = create :circle, created_by: user
          put :owners, format: 'js', params: { id: circle.to_param, user: { id: another_user.id } }, session: valid_session
          another_user.reload
          expect(another_user.has_role?(:owner, circle)).to eq true
          delete :remove_owner, format: 'js', params: { id: circle.to_param, user_id: another_user.id }, session: valid_session
          another_user.reload
          expect(another_user.has_role?(:owner, circle)).to eq false
        end
      end

      describe 'Manage evaluations' do
        it 'adds an evaluation to the circle' do
          circle = create :circle, created_by: user
          put :evaluations, format: 'js', params: { id: circle.to_param, evaluation: { id: evaluation.id } }, session: valid_session
          circle.reload
          expect(circle.evaluations.size).to eq 1
          delete :remove_evaluation, format: 'js', params: { id: circle.to_param, evaluation_id: evaluation.id }, session: valid_session
          circle.reload
          expect(circle.evaluations.size).to eq 0
        end
      end

      describe 'Manage profiles' do
        it 'adds a profile to the circle' do
          circle = create :circle, created_by: user
          put :profiles, format: 'js', params: { id: circle.to_param, profile: { id: profile.id } }, session: valid_session
          circle.reload
          expect(circle.profiles.size).to eq 1
          delete :remove_profile, format: 'js', params: { id: circle.to_param, profile_id: profile.id }, session: valid_session
          circle.reload
          expect(circle.profiles.size).to eq 0
        end
      end
    end
  end
end
