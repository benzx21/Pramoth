package PramothVM.utilities.tests;


import PramothVM.steps.FeatureContext;
import PramothVM.utilities.FormatUtils;
import PramothVM.utilities.SwiftUtils;
import org.junit.Assert;
import org.junit.Test;

import static PramothVM.constants.Utility.CONTEXT_PARAM_CUSTODIAN_TRADE_REF;


public class TestSwiftUtils {

    @Test
    public void testDataFunction() {

        String message = "{1:F01PARBFRPPDXXX0001000000}{2:I545IGLUGB2LXXXXN}{3:{108:ISI419041A5GD000}}{4:\n" +
                "  :16R:GENL\n" +
                "  :20C::SEME//@context(LAST_CUSTODIAN_TRADE_REF)\n" +
                "  :23G:NEWM\n" +
                "  :16R:LINK\n" +
                "  :13A::LINK//541\n" +
                "  :20C::RELA//@context(LAST_CUSTODIAN_TRADE_REF)\n" +
                "  :16S:LINK\n" +
                "  :16S:GENL\n" +
                "  :16R:TRADDET\n" +
                "  :94B::TRAD//EXCH/XXXX\n" +
                "  :98A::TRAD//@date(T)\n" +
                "  :98A::ESET//@date(24-Dec-2023)\n" +
                "  :90B::DEAL//ACTU/USD93,\n" +
                "  :35B:ISIN <isin>\n" +
                "  Google Inc.\n" +
                "  :16S:TRADDET\n" +
                "  :16R:FIAC\n" +
                "  :36B::ESTT//FAMT/@amount(600,000.00)\n" +
                "  :97A::SAFE//41329000010000464070K\n" +
                "  :97A::CASH//41329000010000464070K\n" +
                "  :94F::SAFE//ICSD/MGTCBEBEXXX\n" +
                "  :16S:FIAC\n" +
                "  :16R:SETDET\n" +
                "  :22F::SETR//TRAD\n" +
                "  :16R:SETPRTY\n" +
                "  :95R::DEAG/CEDE/71208\n" +
                "  :16S:SETPRTY\n" +
                "  :16R:SETPRTY\n" +
                "  :95P::SELL//FETALULLISV\n" +
                "  :16S:SETPRTY\n" +
                "  :16R:SETPRTY\n" +
                "  :95P::PSET//CEDELULLXXX\n" +
                "  :16S:SETPRTY\n" +
                "  :16R:AMT\n" +
                "  :19A::ESTT//USD474750,\n" +
                "  :98A::VALU//20220210\n" +
                "  :16S:AMT\n" +
                "  :16S:SETDET\n" +
                "  -}\n";

        FeatureContext.setParam(CONTEXT_PARAM_CUSTODIAN_TRADE_REF, "custody-1234");

        String swiftMessage = SwiftUtils.format(message);

        Assert.assertTrue(swiftMessage.contains(":20C::SEME//custody-1234"));
        Assert.assertTrue(swiftMessage.contains(":98A::TRAD//" + FormatUtils.resolveDateValue("", "T", "yyyyMMdd")));
        Assert.assertTrue(swiftMessage.contains(":98A::ESET//20231224"));
        Assert.assertTrue(swiftMessage.contains(":36B::ESTT//FAMT/600000,"));
    }
}
