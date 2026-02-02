require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:headers) { { "User-Agent" => "Mozilla/5.0" } }
  let(:user) { create(:user) }
  let(:review) { create(:review, user: user) }

  describe "GET /reviews" do
    context "未ログイン" do
      it "200 OK" do
        get reviews_path, headers: headers
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済み" do
      before { sign_in user }

      it "200 OK" do
        get reviews_path, headers: headers
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /reviews/:public_id" do
    context "未ログイン" do
      it "200 OK" do
        get review_path(review), headers: headers
        expect(response).to have_http_status(:ok)
      end

      it "存在しない public_id は 404" do
        get review_path(public_id: "not_exist"), headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context "ログイン済み" do
      before { sign_in user }

      it "200 OK" do
        get review_path(review), headers: headers
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /reviews/new" do
    context "未ログイン" do
      it "ログインページへリダイレクトされる" do
        get new_review_path, headers: headers
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済み" do
      before { sign_in user }

      it "200 OK" do
        get new_review_path, headers: headers
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "POST /reviews" do
    context "未ログイン" do
      it "ログインページへリダイレクトされる" do
        post reviews_path, headers: headers
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済み" do
      before { sign_in user }
      let(:image_tag) { create(:image_tag) }

      it "レビューを作成できる" do
        expect {
          post reviews_path, params: {
            review: {
              content: "テストレビュー",
              is_spoiler: false,
              image_tag_id: image_tag.id,
              book_attributes: {
                title: "本のタイトル"
              }
            }
          }, headers: headers
        }.to change(Review, :count).by(1)

        expect(response).to redirect_to(/\/reviews/)
      end

      it "バリデーションエラーの場合、レビューは作成されない" do
        expect {
          post reviews_path, params: {
            review: {
              content: "",
              is_spoiler: false,
              image_tag_id: image_tag.id,
              book_attributes: {
                title: ""
              }
            }
          }, headers: headers
        }.not_to change(Review, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
