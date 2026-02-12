import os
import re
import sys
import time
import requests
import openpyxl
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options

chrome_root = "./tools/chrome_for_test/145.0.7632.45"

def get_webdriver(root_dir):
    chrome_bin = chrome_root + "/chrome-win64/chrome.exe"
    chrome_driver = chrome_root + "/chromedriver-win64/chromedriver.exe"
    options = Options()
    options.binary_location = chrome_bin
    options.add_argument("--no-sandbox")

    service = Service(chrome_driver)
    return webdriver.Chrome(service=service, options=options)

if __name__ =="__main__":
    driver = get_webdriver(chrome_root)

    driver.get("https://www.baidu.com/")
    time.sleep(5)
    driver.quit()
