import staticScrapper
import time

while True:
    try :
        staticScrapper.fetch_all()
        staticScrapper.print_errors_summary()
        print("Runner finished sleeping for one hour...")
        time.sleep(3600)
    except Exception as e:
        staticScrapper.treat_errors(e, "fetch_all")
        pass
    except KeyboardInterrupt as e:
        staticScrapper.clear_screen()
        print("Script Stopped")
        staticScrapper.print_errors_summary()
        break


    
