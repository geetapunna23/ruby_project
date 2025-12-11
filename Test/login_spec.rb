require "selenium-webdriver"
require "rspec"

RSpec.describe "ITVX Login" do
  before(:all) do
    # options = Selenium::WebDriver::Chrome::Options.new
    options = Selenium::WebDriver::Chrome::Options.new(logging_prefs: { browser: 'ALL' },
                                                         detach: true, args: ['--ignore-certificate-errors',
                                                                              '--no-sandbox',
                                                                              '--disable-gpu',
                                                                              '--disable-web-security',
                                                                              '--disable-site-isolation-trials',
                                                                              '--autoplay-policy=no-user-gesture-required'])

    options.add_argument("--start-maximized")

    @driver = Selenium::WebDriver.for :chrome, options: options
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)
  end

  after(:all) do
    @driver.quit
  end

  it "logs into ITVX" do
    email = "geeta.punna@itv.com"
    password = "111111"

    @driver.navigate.to "https://www.itv.com/"

    # Accept cookies (if shown)
    begin
      accept_button = @wait.until do
        @driver.find_element(:id, "cassie_accept_all_pre_banner")
      end
      accept_button.click
    rescue Selenium::WebDriver::Error::TimeoutError
      puts "No cookie popup shown."
    end

    # Click Sign In
    sign_in_button = @wait.until do
      @driver.find_element(:css, "a[data-testid='navigation-user-link']")
    end
    sign_in_button.click

    # Enter email
    email_field = @wait.until do
      @driver.find_element(:id, "email")
    end
    email_field.send_keys(email)
    @driver.find_element(:css, "button[data-testid='signInButton']").click

    # Enter password
    password_field = @wait.until do
      @driver.find_element(:id, "password")
    end
    password_field.send_keys(password)
    @driver.find_element(:css, "[data-testid='signInButton']").click

    # Validate login — simplest way is to wait for the "My ITV" icon
    @wait.until do
      @driver.find_element(:css, "div[data-testid='profileAvatarWrapper']")
    end
  end
end