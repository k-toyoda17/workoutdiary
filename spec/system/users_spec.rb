require 'rails_helper'

describe 'ユーザー管理機能', type: :system do
  let(:adminuser) { create(:user, name: '管理ユーザー', email: 'adminuser@example.com', admin: true) }
  let(:genuser) { create(:user, name: '一般ユーザー', email: 'genuser@example.com') }

  shared_examples '新規登録' do
    before do
      visit new_admin_user_path
      fill_in '名前', with: '一般ユーザー'
      fill_in 'メールアドレス', with: 'genuser@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード(確認)', with: 'password'
      click_button '登録する'
    end
  end

  shared_examples 'ログイン' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログインする'
    end
  end


  describe '一般ユーザー機能' do
    context '新規登録機能' do
      include_context '新規登録'
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '一般ユーザー'
      end
    end

    context '詳細表示機能' do
      let(:login_user) { genuser }
      include_context 'ログイン'
      before do
        visit admin_user_path(genuser)
      end
      it '一般ユーザーの詳細が表示される' do
        expect(page).to have_content 'genuser@example.com'
      end
    end

    context '編集機能' do
      let(:login_user) { genuser }
      include_context 'ログイン'
      before do
        visit edit_admin_user_path(id: genuser.id)
        fill_in '名前', with: '編集後ユーザー'
        fill_in 'メールアドレス', with: 'reviseduser@example.com'
        click_button '登録する'
      end
      it 'ユーザーが正常に編集される' do
        expect(page).to have_selector '.alert-success', text: '編集後ユーザー'
        visit admin_user_path(genuser)
        expect(page).to have_content 'reviseduser@example.com'
      end
    end

    context 'ログアウト機能' do
      let(:login_user) { genuser }
      include_context 'ログイン'
      before do
        click_on 'ログアウト'
      end
      it 'ログアウトできる' do
        expect(page).to have_selector '.alert-success', text: 'ログアウトしました。'
      end
    end
  end

  describe '管理ユーザー機能' do
    context '管理ユーザーがログインしているとき' do
      let(:login_user) { adminuser }
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { genuser }

      it '管理ユーザーが作成したユーザーが表示されない' do
        expect(page).to have_no_content '管理ユーザーのユーザー'
      end
    end
  end

  describe '新規作成機能' do
    let(:login_user) { adminuser }

    context '新規作成画面でユーザー名を入力したとき' do
      let(:task_name) { '新規ユーザー' }
      let(:task_activity_at) { '2020-01-01 00:00:00' }

      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '新規ユーザー'
      end
    end

    context '新規作成画面でユーザー名を入力しなかったとき' do
      let(:task_name) { '' }
      let(:task_activity_at) { '2020-01-01 00:00:00' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content 'ユーザー名を入力してください'
        end
      end
    end

    context '新規作成画面で実施日を入力しなかったとき' do
      let(:task_name) { '新規ユーザー' }
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
      fill_in 'ユーザー名', with: task_name
      fill_in 'task[activity_at]', with: task_activity_at
      click_button '更新する'
    end

    context 'ユーザー名のみを編集したとき' do
      let(:task_name) { '編集後ユーザー' }
      let(:task_activity_at) { '' }

      it 'ユーザー名が正常に編集される' do
        expect(page).to have_selector '.alert-success', text: '編集後ユーザー'
      end
    end

    context '実施日を編集したとき' do
      let(:task_name) { '編集後ユーザー' }
      let(:task_activity_at) { '2020-03-31 20:00:00' }

      it '実施日が正常に編集される' do
        expect(page).to have_content '2020年03月31日(火) 20時00分'
      end
    end
  end

  describe '削除機能' do
    let(:login_user) { adminuser }

    it '削除できる' do
      click_on '削除'

      expect {
        expect(page.driver.browser.switch_to.alert.text).to eq "ユーザー「管理ユーザーのユーザー」を削除します。よろしいですか？"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ユーザー「管理ユーザーのユーザー」を削除しました。残りのユーザーは0件です。'
      }.to change{ Task.count }.by(-1)
    end
  end
end