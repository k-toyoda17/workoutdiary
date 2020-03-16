require 'rails_helper'

describe 'トレーニング管理機能', type: :system do
  # 管理ユーザー,一般ユーザーを作成しておく
  let(:adminuser) { create(:user, name: '管理ユーザー', email: 'adminuser@example.com', admin: true) }
  let(:genuser) { create(:user, name: '一般ユーザー', email: 'genuser@example.com') }
  # 作成者が管理ユーザーであるトレーニングを作成しておく
  let!(:task_a) { create(:task, name: '管理ユーザーのトレーニング', user: adminuser) }

  before do
    # ログインの共通処理
    visit login_path # ログイン画面にアクセスする
    fill_in 'メールアドレス', with: login_user.email # メールアドレスを入力する
    fill_in 'パスワード', with: login_user.password # パスワードを入力する
    click_button 'ログインする' # ログインボタンを押下する
  end

  shared_examples '管理ユーザーが作成したトレーニングが表示される' do
    it { expect(page).to have_content '管理ユーザーのトレーニング' }
  end

  shared_examples '新規トレーニングを作成する' do
    before do
      visit new_task_path
      fill_in 'トレーニング名', with: task_name
      fill_in 'task[activity_at]', with: task_activity_at
      click_button '登録する'
    end
  end

  describe '一覧表示機能' do
    context '管理ユーザーがログインしているとき' do
      # 管理ユーザーでログインする
      let(:login_user) { adminuser }

      it_behaves_like '管理ユーザーが作成したトレーニングが表示される'
    end

    context 'ユーザーBがログインしているとき' do
      # ユーザーBでログインする
      let(:login_user) { genuser }

      it '管理ユーザーが作成したトレーニングが表示されない' do
        expect(page).to have_no_content '管理ユーザーのトレーニング'
      end
    end
  end

  describe '詳細表示機能' do
    context '管理ユーザーがログインしているとき' do
      # 管理ユーザーでログインする
      let(:login_user) { adminuser }

      # トレーニングの詳細ページへアクセスする
      before do
        visit task_path(task_a)
      end

      it_behaves_like '管理ユーザーが作成したトレーニングが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { adminuser }

    include_context '新規トレーニングを作成する'

    context '新規作成画面でトレーニング名を入力したとき' do
      let(:task_name) { '新規トレーニング' }
      let(:task_activity_at) { '2020-01-01 00:00:00' }

      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規トレーニング'
      end
    end

    context '新規作成画面でトレーニング名を入力しなかったとき' do
      let(:task_name) { '' }
      let(:task_activity_at) { '2020-01-01 00:00:00' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content 'トレーニング名を入力してください'
        end
      end
    end

    context '新規作成画面で実施日を入力しなかったとき' do
      let(:task_name) { '新規トレーニング' }
      let(:task_activity_at) { '' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '実施日を入力してください'
        end
      end
    end
  end

  describe '編集機能' do
    let(:login_user) { adminuser }

    before do
      visit edit_task_path(id: task_a.id)
      fill_in 'トレーニング名', with: task_name
      click_button '更新する'
    end

    context 'トレーニング名を編集したとき' do
      let(:task_name) { '編集後トレーニング' }

      it 'トレーニング名が正常に編集される' do
        expect(page).to have_selector '.alert-success', text: '編集後トレーニング'
      end
    end
  end
end
