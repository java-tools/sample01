import re
from playwright.sync_api import Page, expect


def test_homepage_has_Playwright_in_title_and_get_started_link_linking_to_the_intro_page(page: Page):
    page.goto("http://localhost/login")

    # Expect a title "to contain" a substring.
    expect(page).to_have_title(re.compile("openQA"))

    # create a locator
    get_started = page.locator("text=Manage API keys")
    print("got page ...")
    # Expect an attribute "to be strictly equal" to the value.
    expect(get_started).to_have_attribute("href", "/api_keys")
    page.screenshot(path="screenshot01.png", full_page=True)
    # Click the get started link.
    get_started.click()
    print("click on link login")
    page.goto("http://localhost/api_keys")
    page.screenshot(path="screenshot02.png", full_page=True)
    # Expects the URL to contain intro.
    # expect(page).to_have_url(re.compile(".*login"))

    page.locator("#api-keys-tbody").screenshot(path="api_keys.png")
    print("click comlete ...")