require 'rails_helper'

describe 'トレーニング管理機能', type: :system do
  # ユーザーA,Bを作成しておく
  let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@example.com', admin: true) }
  let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@example.com') }
  # 作成者がユーザーAであるトレーニングを作成しておく
  let!(:task_a) { create(:task, name: '最初のトレーニング', user: user_a) }

  before do
    # ログインの共通処理
    visit login_path # ログイン画面にアクセスする
    fill_in 'メールアドレス', with: login_user.email # メールアドレスを入力する
    fill_in 'パスワード', with: login_user.password # パスワードを入力する
    click_button 'ログインする' # ログインボタンを押下する
  end

  # 作成済みのトレーニングの名称が画面上に表示されていることを確認
  shared_examples_for 'ユーザーAが作成したトレーニングが表示される' do
    it { expect(page).to have_content '最初のトレーニング' }
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      # ユーザーAでログインする
      let(:login_user) { user_a }

      it_behaves_like 'ユーザーAが作成したトレーニングが表示される'
    end

    context 'ユーザーBがログインしているとき' do
      # ユーザーBでログインする
      let(:login_user) { user_b }

      it 'ユーザーAが作成したトレーニングが表示されない' do
        # ユーザーAが作成したトレーニングの名称が画面上に表示されていないことを確認
        expect(page).to have_no_content '最初のトレーニング'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      # ユーザーAでログインする
      let(:login_user) { user_a }

      # トレーニングの詳細ページへアクセスする
      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したトレーニングが表示される'
    end
  end

  describe '新規作成機能' do
    # ユーザーAでログインする
    let(:login_user) { user_a }

    before do
      # 新規トレーニングを作成しておく
      visit new_task_path
      fill_in '種目', with: task_name
      click_button '登録する'
    end

    context '新規作成画面で種目を入力したとき' do
      let(:task_name) { '新規作成のテストを書く' }

      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end

    context '新規作成画面で種目を入力しなかったとき' do
      let(:task_name) { '' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '種目を入力してください'
        end
      end
    end
  end
end
