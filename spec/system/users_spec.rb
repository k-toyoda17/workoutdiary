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
    describe '新規登録機能' do
      include_context '新規登録'
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '一般ユーザー'
      end
    end

    describe '詳細表示機能' do
      let(:login_user) { genuser }
      include_context 'ログイン'
      before do
        visit admin_user_path(genuser)
      end
      it '一般ユーザーの詳細が表示される' do
        expect(page).to have_content 'genuser@example.com'
      end
    end

    describe '編集機能' do
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

    describe 'ログアウト機能' do
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
    let(:login_user) { adminuser }
    include_context 'ログイン'
    include_context '新規登録'
    describe '新規登録機能' do
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: '一般ユーザー'
      end
    end

    describe 'ユーザー詳細機能' do
      it '新規登録したユーザーの詳細が表示される' do
        expect(page).to have_content 'ユーザーの詳細'
        expect(page).to have_content 'genuser@example.com'
      end
    end

    describe 'ユーザー一覧表示機能' do
      context '管理ユーザーの場合' do
        before do
          visit admin_users_path
        end
        it '新規登録したユーザーが一覧に表示される' do
          expect(page).to have_content 'ユーザー一覧'
          expect(page).to have_content 'genuser@example.com'
        end
      end

      context '一般ユーザーの場合' do
        before do
          click_on 'ログアウト'
        end
        let(:loginuser) { create(:user, name: 'ログインユーザー', email: 'login@example.com') }
        let(:login_user) { loginuser }
        include_context 'ログイン'
        it 'トレーニング一覧にリダイレクトされる' do
          visit admin_users_path
          expect(page).to have_selector '.alert-success', text: '権限がありません。'
        end
      end
    end

    describe 'ユーザー編集機能' do
      context '管理ユーザーを編集する場合' do
        before do
          visit edit_admin_user_path(id: adminuser.id)
          fill_in '名前', with: '編集後管理ユーザー'
          fill_in 'メールアドレス', with: 'revisedadminuser@example.com'
          click_button '登録する'
        end
        it '管理ユーザーが正常に編集される' do
          expect(page).to have_selector '.alert-success', text: '編集後管理ユーザー'
          visit admin_user_path(adminuser)
          expect(page).to have_content 'revisedadminuser@example.com'
        end

        context '一般ユーザーを編集する場合' do
          before do
            visit admin_users_path
            click_link '一般ユーザー'
            click_on '編集'
          end
          it 'トレーニング一覧にリダイレクトされる' do
            expect(page).to have_content 'トレーニング一覧'
            expect(page).to have_selector '.alert-success', text: '権限がありません。'
          end
        end
      end
    end

    describe 'ユーザー削除機能' do
      before do
        visit admin_users_path
      end
      it '一般ユーザーが正常に削除される' do
        click_on '削除'
        expect {
          expect(page.driver.browser.switch_to.alert.text).to eq "ユーザー「一般ユーザー」を削除します。よろしいですか？"
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_selector '.alert-success', text: '一般ユーザー'
        }.to change{ User.count }.by(-1)
      end
    end
  end
end